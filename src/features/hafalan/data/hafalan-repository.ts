import {
  type CompareResponse,
  CompareResponseSchema,
  type HafalanRow,
  HafalanRowSchema,
  type NotificationRefRow,
  NotificationRefRowSchema,
  SetoranRowSchema,
} from "@/features/hafalan/data/schema";
import {
  computeNextLevel,
  computeNextMurajaahDate,
  deriveHafalanStatus,
  type HafalanItem,
  type SetoranRecord,
} from "@/features/hafalan/domain/murajaah";
import { db } from "@/lib/db/client";
import { err, ok, type Result } from "@/lib/result";

const mapHafalanRow = (row: HafalanRow): HafalanItem => ({
  id: row.id,
  surahNumber: row.surah_number,
  level: row.level,
  status: deriveHafalanStatus(
    row.level,
    row.next_murajaah_at,
    row.last_setoran_at,
  ),
  lastSetoranAt: row.last_setoran_at,
  nextMurajaahAt: row.next_murajaah_at,
  note: row.note,
});

const parseSetoranRow = (raw: unknown): SetoranRecord | null => {
  const row = SetoranRowSchema.safeParse(raw);
  if (!row.success) return null;
  let passed = false;
  try {
    const parsedResult = CompareResponseSchema.safeParse(
      JSON.parse(row.data.result_json),
    );
    if (parsedResult.success) {
      passed = parsedResult.data.passed;
    }
  } catch {
    passed = row.data.score >= 75;
  }
  return {
    id: row.data.id,
    hafalanId: row.data.hafalan_id,
    createdAt: row.data.created_at,
    score: row.data.score,
    cer: row.data.cer,
    passed,
  };
};

export const listHafalan = (): Result<readonly HafalanItem[]> => {
  try {
    const rows = db.getAllSync<unknown>(
      "SELECT id, surah_number, level, status, last_setoran_at, next_murajaah_at, note FROM hafalan ORDER BY COALESCE(next_murajaah_at, 0) ASC, surah_number ASC",
    );
    const items: HafalanItem[] = [];
    for (const raw of rows) {
      const parsed = HafalanRowSchema.safeParse(raw);
      if (parsed.success) {
        items.push(mapHafalanRow(parsed.data));
      }
    }
    return ok(items);
  } catch (cause) {
    return err("parse", "Failed to read hafalan list", cause);
  }
};

export const addHafalanTarget = (
  surahNumber: number,
  note?: string,
): Result<HafalanItem> => {
  try {
    const existingRaw = db.getFirstSync<unknown>(
      "SELECT id, surah_number, level, status, last_setoran_at, next_murajaah_at, note FROM hafalan WHERE surah_number = ?",
      [surahNumber],
    );
    if (existingRaw) {
      const existing = HafalanRowSchema.safeParse(existingRaw);
      if (existing.success) {
        return ok(mapHafalanRow(existing.data));
      }
    }

    const id = `hafalan-${surahNumber}-${Date.now()}`;
    db.runSync(
      "INSERT INTO hafalan (id, surah_number, level, status, last_setoran_at, next_murajaah_at, note) VALUES (?, ?, 0, 'new', NULL, NULL, ?)",
      [id, surahNumber, note ?? null],
    );

    return ok({
      id,
      surahNumber,
      level: 0,
      status: "new",
      lastSetoranAt: null,
      nextMurajaahAt: null,
      note: note ?? null,
    });
  } catch (cause) {
    return err("parse", "Failed to save hafalan target", cause);
  }
};

export const deleteHafalanTarget = (hafalanId: string): Result<void> => {
  try {
    db.runSync("DELETE FROM hafalan WHERE id = ?", [hafalanId]);
    return ok(undefined);
  } catch (cause) {
    return err("parse", "Failed to delete hafalan target", cause);
  }
};

export const saveSetoranResult = (params: {
  hafalanId: string;
  compareResult: CompareResponse;
  now?: Date;
}): Result<HafalanItem> => {
  try {
    const now = params.now ?? new Date();
    const nowMs = now.getTime();
    const existingRaw = db.getFirstSync<unknown>(
      "SELECT id, surah_number, level, status, last_setoran_at, next_murajaah_at, note FROM hafalan WHERE id = ?",
      [params.hafalanId],
    );
    const existing = HafalanRowSchema.safeParse(existingRaw);
    if (!existing.success) {
      return err("notFound", "Hafalan target not found");
    }

    const nextLevel = computeNextLevel(
      existing.data.level,
      params.compareResult.passed,
    );
    const nextDate = computeNextMurajaahDate(nextLevel, now);
    const nextMs = nextDate.getTime();
    const nextStatus = deriveHafalanStatus(nextLevel, nextMs, nowMs, nowMs);
    const setoranId = `setoran-${nowMs}-${Math.random().toString(36).slice(2, 8)}`;

    db.withTransactionSync(() => {
      db.runSync(
        "UPDATE hafalan SET level = ?, status = ?, last_setoran_at = ?, next_murajaah_at = ? WHERE id = ?",
        [nextLevel, nextStatus, nowMs, nextMs, params.hafalanId],
      );
      db.runSync(
        "INSERT INTO setoran (id, hafalan_id, created_at, score, cer, result_json) VALUES (?, ?, ?, ?, ?, ?)",
        [
          setoranId,
          params.hafalanId,
          nowMs,
          params.compareResult.score,
          params.compareResult.cer,
          JSON.stringify(params.compareResult),
        ],
      );
    });

    return ok({
      id: existing.data.id,
      surahNumber: existing.data.surah_number,
      level: nextLevel,
      status: nextStatus,
      lastSetoranAt: nowMs,
      nextMurajaahAt: nextMs,
      note: existing.data.note,
    });
  } catch (cause) {
    return err("parse", "Failed to save setoran result", cause);
  }
};

export const listSetoranHistory = (
  hafalanId?: string,
): Result<readonly SetoranRecord[]> => {
  try {
    const rows = hafalanId
      ? db.getAllSync<unknown>(
          "SELECT id, hafalan_id, created_at, score, cer, result_json FROM setoran WHERE hafalan_id = ? ORDER BY created_at DESC LIMIT 50",
          [hafalanId],
        )
      : db.getAllSync<unknown>(
          "SELECT id, hafalan_id, created_at, score, cer, result_json FROM setoran ORDER BY created_at DESC LIMIT 100",
        );

    const records: SetoranRecord[] = [];
    for (const raw of rows) {
      const parsed = parseSetoranRow(raw);
      if (parsed) records.push(parsed);
    }
    return ok(records);
  } catch (cause) {
    return err("parse", "Failed to read setoran history", cause);
  }
};

export const getNotificationRef = (
  hafalanId: string,
): NotificationRefRow | null => {
  try {
    const raw = db.getFirstSync<unknown>(
      "SELECT id, hafalan_id, notification_id, scheduled_for FROM notification_ref WHERE hafalan_id = ?",
      [hafalanId],
    );
    const parsed = NotificationRefRowSchema.safeParse(raw);
    return parsed.success ? parsed.data : null;
  } catch {
    return null;
  }
};

export const upsertNotificationRef = (params: {
  hafalanId: string;
  notificationId: string;
  scheduledFor: number;
}): void => {
  db.withTransactionSync(() => {
    db.runSync("DELETE FROM notification_ref WHERE hafalan_id = ?", [
      params.hafalanId,
    ]);
    db.runSync(
      "INSERT INTO notification_ref (id, hafalan_id, notification_id, scheduled_for) VALUES (?, ?, ?, ?)",
      [
        `notif-ref-${params.hafalanId}`,
        params.hafalanId,
        params.notificationId,
        params.scheduledFor,
      ],
    );
  });
};

export const deleteNotificationRef = (hafalanId: string): void => {
  db.runSync("DELETE FROM notification_ref WHERE hafalan_id = ?", [hafalanId]);
};
