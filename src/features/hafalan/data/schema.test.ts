import { CompareResponseSchema, HafalanRowSchema } from "./schema";

describe("hafalan data schemas", () => {
  it("parses valid /compare payload", () => {
    const parsed = CompareResponseSchema.safeParse({
      score: 88.5,
      passed: true,
      threshold: 75,
      transcribed: "قل هو الله أحد",
      target: "قل هو الله أحد",
      cer: 0.05,
      word_errors: [{ word: "أحد", type: "substitution" }],
      duration_ms: 4200,
    });
    expect(parsed.success).toBe(true);
    if (parsed.success) {
      expect(parsed.data.word_errors).toHaveLength(1);
    }
  });

  it("defaults optional word_errors and duration_ms", () => {
    const parsed = CompareResponseSchema.safeParse({
      score: 95,
      passed: true,
      threshold: 75,
      transcribed: "الحمد لله",
      target: "الحمد لله",
      cer: 0.01,
    });
    expect(parsed.success).toBe(true);
    if (parsed.success) {
      expect(parsed.data.word_errors).toEqual([]);
      expect(parsed.data.duration_ms).toBe(0);
    }
  });

  it("rejects invalid hafalan row status", () => {
    const parsed = HafalanRowSchema.safeParse({
      id: "h1",
      surah_number: 1,
      level: 0,
      status: "unknown",
      last_setoran_at: null,
      next_murajaah_at: null,
      note: null,
    });
    expect(parsed.success).toBe(false);
  });
});
