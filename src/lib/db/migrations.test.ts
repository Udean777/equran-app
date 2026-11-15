import initSqlJs, { type Database, type SqlJsStatic } from "sql.js";

import { migrations, runMigrations } from "./migrations";

let SQL: SqlJsStatic | null = null;

const loadSqlJs = async (): Promise<SqlJsStatic> => {
  if (!SQL) {
    // Jest runs from the project root, so a repo-relative wasm path resolves.
    SQL = await initSqlJs({
      locateFile: (file) => `node_modules/sql.js/dist/${file}`,
    });
  }
  return SQL;
};

const openDatabase = async (): Promise<Database> =>
  new (await loadSqlJs()).Database();

const asMigrationTarget = (database: Database) => ({
  execSync: (sql: string) => database.exec(sql),
  withTransactionSync: (fn: () => void) => {
    database.exec("BEGIN");
    try {
      fn();
      database.exec("COMMIT");
    } catch (cause) {
      database.exec("ROLLBACK");
      throw cause;
    }
  },
});

const tableNames = (database: Database): string[] =>
  database
    .exec(
      "SELECT name FROM sqlite_master WHERE type = 'table' ORDER BY name",
    )[0]
    ?.values.flat()
    .map(String) ?? [];

const columnNames = (database: Database, table: string): string[] =>
  database
    .exec(`PRAGMA table_info(${table})`)[0]
    ?.values.map((row) => String(row[1])) ?? [];

const userVersion = (database: Database): number =>
  Number(database.exec("PRAGMA user_version")[0]?.values[0]?.[0] ?? 0);

describe("runMigrations", () => {
  it("creates every table and stamps the schema version", async () => {
    const database = await openDatabase();

    runMigrations(asMigrationTarget(database), 0);

    expect(tableNames(database)).toEqual([
      "ayah",
      "hafalan",
      "notification_ref",
      "setoran",
      "surah",
      "tafsir",
    ]);
    expect(columnNames(database, "ayah")).toContain("translation_en");
    expect(userVersion(database)).toBe(migrations.length);
  });

  it("resumes from the stored version without replaying earlier migrations", async () => {
    const database = await openDatabase();
    const target = asMigrationTarget(database);
    target.execSync(migrations[0] ?? "");
    target.execSync("PRAGMA user_version = 1");

    runMigrations(target, 1);

    expect(columnNames(database, "ayah")).toContain("translation_en");
    expect(userVersion(database)).toBe(migrations.length);
  });
});
