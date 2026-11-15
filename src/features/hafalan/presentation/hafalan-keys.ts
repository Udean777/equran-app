export const hafalanKeys = {
  all: ["hafalan"] as const,
  list: () => [...hafalanKeys.all, "list"] as const,
  history: (hafalanId?: string) =>
    [...hafalanKeys.all, "history", hafalanId ?? "all"] as const,
  health: () => [...hafalanKeys.all, "health"] as const,
} as const;
