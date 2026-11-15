/**
 * One SQL string per schema version, applied in order by `migrate()`.
 * Version = index + 1 and is stored in `PRAGMA user_version`.
 */
export const migrations: readonly string[] = [
  `CREATE TABLE IF NOT EXISTS surah (
     number INTEGER PRIMARY KEY NOT NULL,
     name TEXT NOT NULL,
     latin TEXT NOT NULL,
     ayat_count INTEGER NOT NULL,
     revelation TEXT NOT NULL,
     synced_at INTEGER NOT NULL
   );
   CREATE TABLE IF NOT EXISTS ayah (
     surah_number INTEGER NOT NULL,
     number INTEGER NOT NULL,
     text_arabic TEXT NOT NULL,
     text_latin TEXT NOT NULL,
     translation TEXT NOT NULL,
     PRIMARY KEY (surah_number, number)
   );
   CREATE TABLE IF NOT EXISTS tafsir (
     surah_number INTEGER PRIMARY KEY NOT NULL,
     content TEXT NOT NULL,
     synced_at INTEGER NOT NULL
   );
   CREATE TABLE IF NOT EXISTS hafalan (
     id TEXT PRIMARY KEY NOT NULL,
     surah_number INTEGER NOT NULL,
     level INTEGER NOT NULL DEFAULT 0,
     status TEXT NOT NULL,
     last_setoran_at INTEGER,
     next_murajaah_at INTEGER,
     note TEXT
   );
   CREATE TABLE IF NOT EXISTS setoran (
     id TEXT PRIMARY KEY NOT NULL,
     hafalan_id TEXT NOT NULL REFERENCES hafalan(id) ON DELETE CASCADE,
     created_at INTEGER NOT NULL,
     score REAL NOT NULL,
     cer REAL NOT NULL,
     result_json TEXT NOT NULL
   );
   CREATE TABLE IF NOT EXISTS notification_ref (
     id TEXT PRIMARY KEY NOT NULL,
     hafalan_id TEXT NOT NULL REFERENCES hafalan(id) ON DELETE CASCADE,
     notification_id TEXT NOT NULL,
     scheduled_for INTEGER NOT NULL
   );`,
  `ALTER TABLE ayah ADD COLUMN translation_en TEXT;`,
];

type MigrationTarget = Readonly<{
  execSync: (sql: string) => void;
  withTransactionSync: (fn: () => void) => void;
}>;

/** Applies every migration after `fromVersion`, one transaction each. */
export const runMigrations = (
  db: MigrationTarget,
  fromVersion: number,
): void => {
  for (let i = fromVersion; i < migrations.length; i += 1) {
    db.withTransactionSync(() => {
      db.execSync(migrations[i] ?? "");
      db.execSync(`PRAGMA user_version = ${i + 1}`);
    });
  }
};
