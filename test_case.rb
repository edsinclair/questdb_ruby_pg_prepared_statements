#!/usr/bin/env ruby

require "pg"
require "debug"

conn_params_8_1 = { host: 'localhost', port: 8812, user: 'admin', password: 'postgres' }
conn_params_8_2 = { host: 'localhost', port: 48812, user: 'admin', password: 'postgres' }

LIMIT_ERROR_SQL = %Q(SELECT "events".* FROM "events" WHERE "events"."name" = $1 AND "events"."facility" = $2 AND "events"."start_ts" BETWEEN $3 AND $4 LIMIT $5)
NO_LIMIT_ERROR_SQL = %Q(SELECT "events".* FROM "events" WHERE "events"."name" = $1 AND "events"."facility" = $2 AND "events"."start_ts" BETWEEN $3 AND $4 LIMIT 1)
LIMIT_BINDS = ["EGA-03Jan22@09_00_50", "URS17005", "2022-01-03 00:00:00", "2022-01-04 00:00:00", 1]

IN_ERROR_SQL = %Q(SELECT "events".* FROM "events" WHERE "events"."name" IN ($1, $2))
IN_BINDS = ["EGA-03Jan22@08_24_40","EGA-03Jan22@09_00_50"]

conn_8_1 = PG.connect(**conn_params_8_1)
puts "QuestDB version 8.1.4"
puts conn_8_1.exec_params(LIMIT_ERROR_SQL, LIMIT_BINDS).values.join(", ")
puts conn_8_1.exec_params(IN_ERROR_SQL, IN_BINDS).values.join(", ")

conn_8_2 = PG.connect(**conn_params_8_2)
puts "QuestDB version 8.2.1"
puts conn_8_2.exec_params(NO_LIMIT_ERROR_SQL, LIMIT_BINDS).values.join(", ")

begin
  puts conn_8_2.exec_params(LIMIT_ERROR_SQL, LIMIT_BINDS).values.join(", ")
rescue PG::ServerError => limit_error
  puts limit_error
end

begin
  puts conn_8_2.exec_params(IN_ERROR_SQL, IN_BINDS).values.join(", ")
rescue PG::ServerError => in_error
  puts in_error
end

