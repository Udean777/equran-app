import {
  buildAlarmScheduleEntries,
  computeDailyPrayerTimes,
  DEFAULT_COORDINATES,
  formatCountdown,
} from "./prayer-times";

describe("prayer-times domain", () => {
  it("computes 6 ordered prayer times for Jakarta", () => {
    const morning = new Date(2026, 10, 14, 5, 30, 0);
    const schedule = computeDailyPrayerTimes(DEFAULT_COORDINATES, morning);

    expect(schedule.entries.map((entry) => entry.name)).toEqual([
      "fajr",
      "sunrise",
      "dhuhr",
      "asr",
      "maghrib",
      "isha",
    ]);

    for (let i = 1; i < schedule.entries.length; i += 1) {
      const prev = schedule.entries[i - 1];
      const curr = schedule.entries[i];
      if (!prev || !curr) throw new Error("Expected 6 prayer entries");
      expect(curr.time.getTime()).toBeGreaterThan(prev.time.getTime());
    }
  });

  it("rolls nextPrayer to tomorrow fajr after isha", () => {
    const lateNight = new Date(2026, 10, 14, 23, 30, 0);
    const schedule = computeDailyPrayerTimes(DEFAULT_COORDINATES, lateNight);

    expect(schedule.nextPrayer?.name).toBe("fajr");
    expect(schedule.nextPrayer?.time.getTime()).toBeGreaterThan(
      lateNight.getTime(),
    );
    expect(schedule.remainingMs).toBeGreaterThan(0);
  });

  it("schedules only future fardh prayers across today and tomorrow", () => {
    const midday = new Date(2026, 10, 14, 13, 0, 0);
    const entries = buildAlarmScheduleEntries(DEFAULT_COORDINATES, midday);

    expect(entries.length).toBeGreaterThanOrEqual(5);
    expect(entries.length).toBeLessThanOrEqual(10);
    for (const item of entries) {
      expect(item.triggerAt.getTime()).toBeGreaterThan(midday.getTime());
    }
  });

  it("formats countdown as HH:MM:SS", () => {
    expect(formatCountdown(3_665_000)).toBe("01:01:05");
    expect(formatCountdown(-500)).toBe("00:00:00");
  });
});
