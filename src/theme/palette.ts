import colors from "./colors.json";

export type ColorSchemeName = "light" | "dark";

export type ThemePalette = Readonly<{
  bg: string;
  surface: string;
  surfaceVariant: string;
  border: string;
  borderVariant: string;
  text: string;
  muted: string;
  subtle: string;
  disabled: string;
  primary: string;
  primaryLight: string;
  primaryLighter: string;
  primaryContainer: string;
  onPrimary: string;
  onPrimaryContainer: string;
}>;

export const LIGHT_PALETTE: ThemePalette = colors.light;

export const DARK_PALETTE: ThemePalette = colors.dark;

export const BRAND_COLORS = {
  gold: colors.gold,
  semantic: colors.semantic,
  quran: colors.quran,
  shimmer: colors.shimmer,
  onboarding: colors.onboarding,
} as const;

export const getThemePalette = (
  scheme: ColorSchemeName | undefined,
): ThemePalette => (scheme === "light" ? LIGHT_PALETTE : DARK_PALETTE);
