type Level = "debug" | "info" | "warn" | "error";

const write = (level: Level, message: string, meta?: unknown) => {
  if (!__DEV__ && level === "debug") return;
  console[level](`[qurva] ${message}`, meta ?? "");
};

export const logger = {
  debug: (m: string, meta?: unknown) => write("debug", m, meta),
  info: (m: string, meta?: unknown) => write("info", m, meta),
  warn: (m: string, meta?: unknown) => write("warn", m, meta),
  error: (m: string, meta?: unknown) => write("error", m, meta),
};
