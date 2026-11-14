import { toGlobalAyahNumber } from "./ayat-number";

describe("toGlobalAyahNumber", () => {
  it("maps the first ayah of Al-Fatihah to 1", () => {
    expect(toGlobalAyahNumber(1, 1)).toBe(1);
  });

  it("maps the first ayah of Al-Baqarah to 8", () => {
    expect(toGlobalAyahNumber(2, 1)).toBe(8);
  });

  it("maps the last ayah of An-Nas to 6236", () => {
    expect(toGlobalAyahNumber(114, 6)).toBe(6236);
  });

  it("rejects a surah outside 1..114", () => {
    expect(() => toGlobalAyahNumber(115, 1)).toThrow(RangeError);
    expect(() => toGlobalAyahNumber(0, 1)).toThrow(RangeError);
  });

  it("rejects an ayah below 1", () => {
    expect(() => toGlobalAyahNumber(1, 0)).toThrow(RangeError);
  });
});
