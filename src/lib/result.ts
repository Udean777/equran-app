export type AppErrorCode =
  | "network"
  | "timeout"
  | "parse"
  | "notFound"
  | "permission"
  | "server"
  | "unknown";

export type AppError = { code: AppErrorCode; message: string; cause?: unknown };

export type Result<T> = { ok: true; value: T } | { ok: false; error: AppError };

export const ok = <T>(value: T): Result<T> => ({ ok: true, value });

export const err = <T = never>(
  code: AppErrorCode,
  message: string,
  cause?: unknown,
): Result<T> => ({
  ok: false,
  error: { code, message, cause },
});
