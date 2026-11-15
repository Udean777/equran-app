import {
  computeHafalanStats,
  computeNextLevel,
  computeNextMurajaahDate,
  deriveHafalanStatus,
  getIntervalDaysForLevel,
  MURAJAAH_INTERVAL_DAYS,
} from "./murajaah";

describe("murajaah spaced repetition", () => {
  it("uses [1, 3, 7, 30, 90] day intervals", () => {
    expect(MURAJAAH_INTERVAL_DAYS).toEqual([1, 3, 7, 30, 90]);
    expect(getIntervalDaysForLevel(0)).toBe(1);
    expect(getIntervalDaysForLevel(1)).toBe(3);
    expect(getIntervalDaysForLevel(2)).toBe(7);
    expect(getIntervalDaysForLevel(3)).toBe(30);
    expect(getIntervalDaysForLevel(4)).toBe(90);
    expect(getIntervalDaysForLevel(99)).toBe(90);
  });

  it("increments level on pass up to max and steps back on fail", () => {
    expect(computeNextLevel(0, true)).toBe(1);
    expect(computeNextLevel(3, true)).toBe(4);
    expect(computeNextLevel(4, true)).toBe(4);
    expect(computeNextLevel(2, false)).toBe(1);
    expect(computeNextLevel(0, false)).toBe(0);
  });

  it("computes next murajaah date accurately", () => {
    const base = new Date("2026-11-14T08:00:00.000Z");
    const next = computeNextMurajaahDate(2, base);
    expect(next.toISOString()).toBe("2026-11-21T08:00:00.000Z");
  });

  it("derives status across new, learning, due, and mastered", () => {
    const now = 1_700_000_000_000;
    expect(deriveHafalanStatus(0, null, null, now)).toBe("new");
    expect(deriveHafalanStatus(1, now + 10_000, now - 5_000, now)).toBe(
      "learning",
    );
    expect(deriveHafalanStatus(2, now - 1, now - 10_000, now)).toBe("due");
    expect(deriveHafalanStatus(4, now + 10_000, now - 5_000, now)).toBe(
      "mastered",
    );
  });

  it("computes aggregate hafalan stats", () => {
    const now = 1_700_000_000_000;
    const stats = computeHafalanStats(
      [
        {
          id: "h1",
          surahNumber: 1,
          level: 4,
          status: "mastered",
          lastSetoranAt: now - 1000,
          nextMurajaahAt: now + 100_000,
          note: null,
        },
        {
          id: "h2",
          surahNumber: 112,
          level: 1,
          status: "learning",
          lastSetoranAt: now - 100_000,
          nextMurajaahAt: now - 100,
          note: null,
        },
      ],
      [
        {
          id: "s1",
          hafalanId: "h1",
          createdAt: now - 1000,
          score: 92,
          cer: 0.04,
          passed: true,
        },
        {
          id: "s2",
          hafalanId: "h2",
          createdAt: now - 500,
          score: 78,
          cer: 0.15,
          passed: true,
        },
      ],
      now,
    );

    expect(stats).toEqual({
      totalSurahs: 2,
      dueCount: 1,
      masteredCount: 1,
      totalSessions: 2,
      averageScore: 85,
    });
  });
});
