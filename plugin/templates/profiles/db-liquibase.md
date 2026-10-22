# Repo profile: Database scripts (Liquibase)

Detect: `changelog/db.changelog-master.yaml`, or a repo of loose `.sql` scripts (then adopt Liquibase first; see "Adopting").

Engine: <postgres | oracle>. One engine per repo; set `DB_ENGINE` in the project's CI/CD variables.

## Why Liquibase

- Plain SQL stays plain SQL (formatted SQL changelogs), so DBAs and devs keep writing the scripts they write today.
- It records what ran where (`DATABASECHANGELOG` table), so the pipeline can run "everything not yet applied" against any environment safely and repeatably.
- It can show the exact SQL before running it (`update-sql`), test rollbacks (`update-testing-rollback`) and roll back to a tag.
- It supports every mainstream engine. Flyway is the simpler alternative, but its undo scripts are a paid feature.

## Layout

```
changelog/
  db.changelog-master.yaml          # includeAll: changes/, in file-name order
  changes/
    2026-10-22-0001-PROJ-123-add-order-status.sql
    ...
  repeatable/                       # views, procedures, functions: runOnChange
```

A change file:

```sql
--liquibase formatted sql

--changeset jdoe:PROJ-123-1
ALTER TABLE orders ADD status VARCHAR(20) DEFAULT 'NEW' NOT NULL;
--rollback ALTER TABLE orders DROP COLUMN status;
```

Rules:
- **Never edit a changeset that has run anywhere.** Its checksum is recorded; fix forward with a new changeset.
- Every changeset has a `--rollback` (or `--rollback empty` with a reason in a comment when none is possible, such as a data delete).
- One logical change per changeset; the id includes the issue key.
- File names sort in apply order (`YYYY-MM-DD-NNNN-<issue>-<slug>.sql`).
- Views, procedures and functions live in `repeatable/` with `runOnChange:true` and `CREATE OR REPLACE`.
- Environment-specific data uses `context:` (`dev`, `test`, `prod`); schema changes never do.

Engine notes:
- **Oracle** commits every DDL statement on its own, so a changeset that fails halfway can't roll back. Put **one DDL statement per changeset**.
- **Oracle PL/SQL** (packages, procedures, triggers) contains semicolons: use `--changeset ... splitStatements:false endDelimiter:/` and end the block with `/`.
- **Postgres** runs DDL inside transactions, so a failed changeset rolls back cleanly, but `CREATE INDEX CONCURRENTLY` can't run in one: give it `runInTransaction:false`.
- Use `CREATE OR REPLACE` for repeatables on both engines (Postgres views can't drop columns that way; drop and recreate in a changeset instead).

## Checks

- Validate: `liquibase validate`
- Apply + rollback test against a **throwaway** database only, the same images CI uses:
  - Postgres: `docker run -d --name testdb -p 5432:5432 -e POSTGRES_DB=app -e POSTGRES_USER=app -e POSTGRES_PASSWORD=throwaway <POSTGRES_IMAGE>`, URL `jdbc:postgresql://localhost:5432/app`
  - Oracle: `docker run -d --name testdb -p 1521:1521 -e ORACLE_PASSWORD=throwaway -e APP_USER=app -e APP_USER_PASSWORD=throwaway <ORACLE_IMAGE>`, URL `jdbc:oracle:thin:@//localhost:1521/FREEPDB1` (wait until the log says the database is ready)
  - then `liquibase update-testing-rollback` with that URL, user `app`. Remove the container afterwards.
- Preview: `liquibase update-sql` shows the SQL that would run.

## Pipeline (`liquibase.gitlab-ci.yml`)

- **MR**: validate, then apply + rollback test against a database service container. For DBA review, attach `update-sql` output for each environment (read-only credentials).
- **Default branch**: deploy to `dev` automatically, then `test` <automatically | manually>.
- **prod**: manual job on a **protected environment with deployment approval** (Ultimate) by the DBA group. It runs `tag <pipeline id>` before `update`, so `rollback --tag` can undo the release.
- Credentials are environment-scoped, masked CI/CD variables (`LIQUIBASE_COMMAND_URL`, `_USERNAME`, `_PASSWORD`), or come from Vault through `id_tokens`.
- `CODEOWNERS` makes the DBA group a required approver for `changelog/`.

## Adopting (existing databases and loose scripts)

1. Baseline: `liquibase generate-changelog` against prod (or the current DDL scripts) into `changelog/baseline/`, reviewed by a DBA.
2. On every existing environment, run `liquibase changelog-sync` once (a human, through the pipeline), which marks the baseline as applied without running it.
3. From then on, every change is a new changeset. Old loose scripts move to `archive/` and are never run again.

## Agent limits

- Agents write changesets and run them **only** against a throwaway local or CI database. Never against dev, test or prod, and never with shared credentials.
- Deploy, `changelog-sync`, `rollback` and `tag` jobs are triggered by humans.
- Data-changing changesets (UPDATE/DELETE on real data, backfills) are `ready-for-human`: an agent may draft one, but a DBA owns it.
