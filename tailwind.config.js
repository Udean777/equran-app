const colors = require("./src/theme/colors.json");

/** @type {import('tailwindcss').Config} */
module.exports = {
  darkMode: "class",
  content: ["./src/**/*.{ts,tsx}"],
  presets: [require("nativewind/preset")],
  theme: {
    extend: {
      colors: {
        bg: "rgb(var(--color-bg) / <alpha-value>)",
        surface: "rgb(var(--color-surface) / <alpha-value>)",
        "surface-variant": "rgb(var(--color-surface-variant) / <alpha-value>)",
        "surface-tint": "rgb(var(--color-surface-tint) / <alpha-value>)",
        border: "rgb(var(--color-border) / <alpha-value>)",
        "border-variant": "rgb(var(--color-border-variant) / <alpha-value>)",
        primary: "rgb(var(--color-primary) / <alpha-value>)",
        "primary-light": colors.light.primaryLight,
        "primary-lighter": colors.light.primaryLighter,
        "primary-container":
          "rgb(var(--color-primary-container) / <alpha-value>)",
        "on-primary": "rgb(var(--color-on-primary) / <alpha-value>)",
        "on-primary-container":
          "rgb(var(--color-on-primary-container) / <alpha-value>)",
        text: "rgb(var(--color-text) / <alpha-value>)",
        muted: "rgb(var(--color-muted) / <alpha-value>)",
        subtle: "rgb(var(--color-subtle) / <alpha-value>)",
        disabled: "rgb(var(--color-disabled) / <alpha-value>)",
        gold: {
          DEFAULT: colors.gold.DEFAULT,
          light: colors.gold.light,
          lighter: colors.gold.lighter,
          dark: colors.gold.dark,
        },
        "on-gold": colors.gold.onGold,
        error: colors.semantic.error,
        "on-error": colors.semantic.onError,
        "error-container": colors.semantic.errorContainer,
        success: colors.semantic.success,
        "success-container": colors.semantic.successContainer,
        warning: colors.semantic.warning,
        "warning-container": colors.semantic.warningContainer,
        "mekah-badge": colors.quran.mekahBadge,
        "mekah-badge-text": colors.quran.mekahBadgeText,
        "madinah-badge": colors.quran.madinahBadge,
        "madinah-badge-text": colors.quran.madinahBadgeText,
        "onboarding-bg": colors.onboarding.bg,
        "onboarding-surface": colors.onboarding.bgEnd,
        "onboarding-text": colors.onboarding.text,
        "onboarding-muted": colors.onboarding.muted,
      },
      fontFamily: {
        arabic: ["KFGQPCUthmanicScriptHAFS"],
        serif: ["Amiri", "Amiri-Bold"],
      },
    },
  },
  plugins: [],
};
