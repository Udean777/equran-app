import * as SQLite from "expo-sqlite";

import { runMigrations } from "@/lib/db/migrations";

export const db = SQLite.openDatabaseSync("qurva.db");

export const migrate = (): void => {
  db.execSync("PRAGMA journal_mode = WAL; PRAGMA foreign_keys = ON;");
  const { user_version: version } = db.getFirstSync<{ user_version: number }>(
    "PRAGMA user_version",
  ) ?? {
    user_version: 0,
  };

  runMigrations(db, version);
};
