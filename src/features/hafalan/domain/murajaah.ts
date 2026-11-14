export const MURAJAAH_INTERVAL_DAYS = [1, 3, 7, 30, 90] as const;

export type HafalanStatus = "new" | "learning" | "due" | "mastered";

export type HafalanItem = Readonly<{
  id: string;
  surahNumber: number;
  level: number;
  status: HafalanStatus;
  lastSetoranAt: number | null;
  nextMurajaahAt: number | null;
  note: string | null;
}>;

export type SetoranRecord = Readonly<{
  id: string;
  hafalanId: string;
  createdAt: number;
  score: number;
  cer: number;
  passed: boolean;
}>;

export type HafalanStats = Readonly<{
  totalSurahs: number;
  dueCount: number;
  masteredCount: number;
  totalSessions: number;
  averageScore: number | null;
}>;

const MAX_LEVEL = MURAJAAH_INTERVAL_DAYS.length - 1;
const MS_PER_DAY = 24 * 60 * 60 * 1000;

export const computeNextLevel = (
  currentLevel: number,
  passed: boolean,
): number => {
  const clamped = Math.max(0, Math.min(MAX_LEVEL, Math.floor(currentLevel)));
  if (passed) {
    return Math.min(MAX_LEVEL, clamped + 1);
  }
  return Math.max(0, clamped - 1);
};

export const getIntervalDaysForLevel = (level: number): number => {
  const clamped = Math.max(0, Math.min(MAX_LEVEL, Math.floor(level)));
  return MURAJAAH_INTERVAL_DAYS[clamped] ?? 1;
};

export const computeNextMurajaahDate = (
  level: number,
  from: Date = new Date(),
): Date => {
  const days = getIntervalDaysForLevel(level);
  return new Date(from.getTime() + days * MS_PER_DAY);
};

export const deriveHafalanStatus = (
  level: number,
  nextMurajaahAt: number | null,
  lastSetoranAt: number | null,
  nowMs: number = Date.now(),
): HafalanStatus => {
  if (lastSetoranAt === null) {
    return "new";
  }
  if (nextMurajaahAt !== null && nextMurajaahAt <= nowMs) {
    return "due";
  }
  if (level >= MAX_LEVEL) {
    return "mastered";
  }
  return "learning";
};

export const computeHafalanStats = (
  items: readonly HafalanItem[],
  setorans: readonly SetoranRecord[],
  nowMs: number = Date.now(),
): HafalanStats => {
  let dueCount = 0;
  let masteredCount = 0;

  for (const item of items) {
    const liveStatus = deriveHafalanStatus(
      item.level,
      item.nextMurajaahAt,
      item.lastSetoranAt,
      nowMs,
    );
    if (liveStatus === "due") dueCount += 1;
    if (liveStatus === "mastered") masteredCount += 1;
  }

  const totalSessions = setorans.length;
  const averageScore =
    totalSessions > 0
      ? setorans.reduce((sum, s) => sum + s.score, 0) / totalSessions
      : null;

  return {
    totalSurahs: items.length,
    dueCount,
    masteredCount,
    totalSessions,
    averageScore,
  };
};
