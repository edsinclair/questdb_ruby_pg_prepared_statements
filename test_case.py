#!/usr/bin/env python

import psycopg

LIMIT_ERROR_SQL = """SELECT "events".* FROM "events" WHERE "events"."name" = $1 AND "events"."facility" = $2 AND "events"."start_ts" BETWEEN $3 AND $4 LIMIT $5"""
LIMIT_BINDS = ["EGA-03Jan22@09_00_50", "URS17005", "2022-01-03 00:00:00", "2022-01-04 00:00:00", 1]

IN_ERROR_SQL = """SELECT "events".* FROM "events" WHERE "events"."name" IN ($1, $2)"""
IN_BINDS = ["EGA-03Jan22@08_24_40","EGA-03Jan22@09_00_50"]

# Connect to an existing database
print("QuestDB version 8.1.4")
with psycopg.connect("host=localhost user=admin password=postgres port=8812", cursor_factory=psycopg.RawCursor) as conn:
    with conn.cursor() as cur:
        print("executing with LIMIT bind variable")
        cur.execute(LIMIT_ERROR_SQL, LIMIT_BINDS)
        for record in cur:
            print(record)
        print("executing with IN bind variable")
        cur.execute(IN_ERROR_SQL, IN_BINDS)
        for record in cur:
            print(record)

print("QuestDB version 8.2.0")
with psycopg.connect("host=localhost user=admin password=postgres port=48812", cursor_factory=psycopg.RawCursor) as conn:
    with conn.cursor() as cur:
        print("executing with LIMIT bind variable")
        cur.execute(LIMIT_ERROR_SQL, LIMIT_BINDS)
        for record in cur:
            print(record)
        print("executing with IN bind variable")
        cur.execute(IN_ERROR_SQL, IN_BINDS)
        for record in cur:
            print(record)
