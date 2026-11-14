const colors = require("./src/theme/colors.json");

/** @type {import('tailwindcss').Config} */
module.exports = {
  content: ["./src/**/*.{ts,tsx}"],
  presets: [require("nativewind/preset")],
  theme: {
    extend: {
      colors: {
        bg: colors.bg,
        surface: colors.surface,
        border: colors.border,
        primary: colors.primary,
        "on-primary": colors.onPrimary,
        text: colors.text,
        muted: colors.muted,
      },
      fontFamily: {
        arabic: ["KFGQPCUthmanicScriptHAFS"],
        serif: ["Amiri", "Amiri-Bold"],
      },
    },
  },
  plugins: [],
};
