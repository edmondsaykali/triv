import { mkdir, readdir, rm, writeFile } from "node:fs/promises";
import { dirname, join } from "node:path";
import { fileURLToPath } from "node:url";

const __dirname = dirname(fileURLToPath(import.meta.url));
const outputDir = join(__dirname, "..", "sources", "platinur_analytics");

const clickhouseUrl = process.env.CLICKHOUSE_URL || "http://clickhouse:8123";
const primaryClickhouseDatabase = process.env.CLICKHOUSE_DATABASE || "marts";
const fallbackClickhouseDatabases = (process.env.CLICKHOUSE_FALLBACK_DATABASES || "")
  .split(",")
  .map((database) => database.trim())
  .filter(Boolean);
const clickhouseUser = process.env.CLICKHOUSE_USER || "app";
const clickhousePassword = process.env.CLICKHOUSE_PASSWORD || "app";

const clickhouseDatabases = [...new Set([primaryClickhouseDatabase, ...fallbackClickhouseDatabases])];

function clickhouseIdentifier(value) {
  if (!/^[A-Za-z0-9_]+$/.test(value)) {
    throw new Error(`Invalid ClickHouse identifier: ${value}`);
  }
  return `\`${value}\``;
}

function clickhouseColumnIdentifier(value) {
  if (!/^[A-Za-z0-9_.]+$/.test(value)) {
    throw new Error(`Invalid ClickHouse column identifier: ${value}`);
  }
  return `\`${value}\``;
}

function clickhouseString(value) {
  return `'${String(value).replace(/\\/g, "\\\\").replace(/'/g, "\\'")}'`;
}

function parseJsonEachRow(body) {
  const lines = body.trim().split("\n").filter(Boolean);
  return lines.map((line) => JSON.parse(line));
}

function csvFileName(tableName) {
  return `${tableName}.csv`;
}

async function clickhouseRequest(sql) {
  const endpoint = new URL(clickhouseUrl);
  endpoint.searchParams.set("user", clickhouseUser);
  endpoint.searchParams.set("password", clickhousePassword);

  const response = await fetch(endpoint, {
    method: "POST",
    body: sql.trim(),
  });

  if (!response.ok) {
    const body = await response.text();
    throw new Error(`ClickHouse request failed with ${response.status}: ${body}`);
  }

  return response.text();
}

async function queryRows(sql) {
  return parseJsonEachRow(await clickhouseRequest(`${sql.trim()} FORMAT JSONEachRow`));
}

async function queryCsv(sql) {
  return clickhouseRequest(`${sql.trim()} FORMAT CSVWithNames`);
}

async function clearPreviousExports() {
  await mkdir(outputDir, { recursive: true });
  await writeFile(join(outputDir, "connection.yaml"), "name: platinur_analytics\ntype: csv\noptions: {}\n", "utf-8");
  const files = await readdir(outputDir);
  await Promise.all(
    files
      .filter((file) => file.endsWith(".csv"))
      .map((file) => rm(join(outputDir, file), { force: true })),
  );
}

async function listAnalyticsTables(databaseName) {
  return queryRows(`
    select
      name
    from system.tables
    where database = ${clickhouseString(databaseName)}
      and is_temporary = 0
      and startsWith(name, '.') = 0
    order by name asc
  `);
}

async function listTableColumns(databaseName, tableName) {
  return queryRows(`
    select
      name
    from system.columns
    where database = ${clickhouseString(databaseName)}
      and table = ${clickhouseString(tableName)}
    order by position asc
  `);
}

await clearPreviousExports();

const exportedTables = new Set();

for (const databaseName of clickhouseDatabases) {
  const tables = await listAnalyticsTables(databaseName);

  for (const table of tables) {
    const tableName = String(table.name || "");
    if (exportedTables.has(tableName)) {
      continue;
    }

    clickhouseIdentifier(tableName);
    const columns = await listTableColumns(databaseName, tableName);
    if (columns.length === 0) {
      continue;
    }

    const columnList = columns.map((column) => clickhouseColumnIdentifier(String(column.name))).join(",\n        ");
    const sql = `
      select
        ${columnList}
      from ${clickhouseIdentifier(databaseName)}.${clickhouseIdentifier(tableName)}
    `;
    const csv = await queryCsv(sql);
    await writeFile(join(outputDir, csvFileName(tableName)), csv, "utf-8");
    exportedTables.add(tableName);
    console.log(`Exported ${databaseName}.${csvFileName(tableName)}`);
  }
}
