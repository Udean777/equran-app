import { z } from "zod";

export const WordErrorItemSchema = z.object({
  word: z.string(),
  expected: z.string().optional(),
  actual: z.string().optional(),
  type: z.string().optional(),
  position: z.number().optional(),
});

export const CompareResponseSchema = z.object({
  score: z.number(),
  passed: z.boolean(),
  threshold: z.number(),
  transcribed: z.string(),
  target: z.string(),
  cer: z.number(),
  word_errors: z.array(WordErrorItemSchema).default([]),
  duration_ms: z.number().default(0),
});

export type WordErrorItem = z.infer<typeof WordErrorItemSchema>;
export type CompareResponse = z.infer<typeof CompareResponseSchema>;

export const HafalanStatusSchema = z.enum([
  "new",
  "learning",
  "due",
  "mastered",
]);

export const HafalanRowSchema = z.object({
  id: z.string(),
  surah_number: z.number().int().positive(),
  level: z.number().int().min(0),
  status: HafalanStatusSchema,
  last_setoran_at: z.number().nullable(),
  next_murajaah_at: z.number().nullable(),
  note: z.string().nullable(),
});

export const SetoranRowSchema = z.object({
  id: z.string(),
  hafalan_id: z.string(),
  created_at: z.number(),
  score: z.number(),
  cer: z.number(),
  result_json: z.string(),
});

export const NotificationRefRowSchema = z.object({
  id: z.string(),
  hafalan_id: z.string(),
  notification_id: z.string(),
  scheduled_for: z.number(),
});

export type HafalanRow = z.infer<typeof HafalanRowSchema>;
export type SetoranRow = z.infer<typeof SetoranRowSchema>;
export type NotificationRefRow = z.infer<typeof NotificationRefRowSchema>;
