import {
  BRAND_COLORS,
  DARK_PALETTE,
  getThemePalette,
  LIGHT_PALETTE,
} from "./palette";

describe("theme palette", () => {
  it("matches the Flutter light palette tokens", () => {
    const palette = getThemePalette("light");
    expect(palette).toEqual(LIGHT_PALETTE);
    expect(palette.bg).toBe("#FAFCFA");
    expect(palette.surface).toBe("#FFFFFF");
    expect(palette.primary).toBe("#1A5C38");
    expect(palette.text).toBe("#0D1F16");
  });

  it("matches the Flutter dark palette tokens and defaults to dark when undefined", () => {
    expect(getThemePalette("dark")).toEqual(DARK_PALETTE);
    expect(getThemePalette(undefined)).toEqual(DARK_PALETTE);
    expect(DARK_PALETTE.bg).toBe("#111312");
    expect(DARK_PALETTE.surface).toBe("#191C1A");
    expect(DARK_PALETTE.primary).toBe("#46A870");
    expect(DARK_PALETTE.onPrimary).toBe("#071F10");
    expect(DARK_PALETTE.text).toBe("#ECEFED");
  });

  it("exposes Flutter gold and onboarding brand colors", () => {
    expect(BRAND_COLORS.gold.DEFAULT).toBe("#C9A84C");
    expect(BRAND_COLORS.gold.onGold).toBe("#3A2800");
    expect(BRAND_COLORS.onboarding.bg).toBe("#0A2E1A");
    expect(BRAND_COLORS.onboarding.bgEnd).toBe("#0D3D22");
  });
});
