#!/usr/bin/env ruby

require "pg"
require "debug"

conn_params_8_1 = { host: 'localhost', port: 8812, user: 'admin', password: 'postgres' }
conn_params_8_2 = { host: 'localhost', port: 48812, user: 'admin', password: 'postgres' }

PROBLEM_SQL = %Q(SELECT "events".* FROM "events" WHERE "events"."name" = $1 AND "events"."facility" = $2 AND "events"."start_ts" BETWEEN $3 AND $4 LIMIT $5)
OKAY_SQL = %Q(SELECT "events".* FROM "events" WHERE "events"."name" = $1 AND "events"."facility" = $2 AND "events"."start_ts" BETWEEN $3 AND $4 LIMIT 1)

binds = ["EGA-03Jan22@09_00_50", "URS17005", "2022-01-03 00:00:00", "2022-01-04 00:00:00", 1]

conn_8_1 = PG.connect(**conn_params_8_1)
puts "QuestDB version 8.1.4"
puts conn_8_1.exec_params(PROBLEM_SQL, binds).values.join(", ")

conn_8_2 = PG.connect(**conn_params_8_2)
puts "QuestDB version 8.2.0"
puts conn_8_2.exec_params(PROBLEM_SQL, binds).values.join(", ")
