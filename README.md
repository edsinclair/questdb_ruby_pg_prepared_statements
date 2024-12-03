## QuestDB
* Run questdb via docker-compose.

  ```
  export QDB_PG_PASSWORD=<password>
  docker-compose up -d questdb-8-1
  docker-compose up -d questdb-8-2

  ```

* Load the table schema:

  ```
  psql "postgres://admin:$QDB_PG_PASSWORD@localhost:8812" < db/questdb_schema.sql
  psql "postgres://admin:$QDB_PG_PASSWORD@localhost:48812" < db/questdb_schema.sql
  ```

* Load the data:

  ```
  psql "postgres://admin:$QDB_PG_PASSWORD@localhost:8812" -c "COPY events FROM 'events.csv' WITH HEADER true"
  psql "postgres://admin:$QDB_PG_PASSWORD@localhost:48812" -c "COPY events FROM 'events.csv' WITH HEADER true"
  ```

* ruby-pg test case requires ruby/bundler

  ```
 	bundle install && ./test_case.rb
  ```

* result:

  ```
  QuestDB version 8.1.4
  2022-01-03 14:00:50.000000, URS17005, EGA-03Jan22@09_00_50, 2022-01-03 14:42:00.000000
  2022-01-03 13:24:40.000000, URS17006, EGA-03Jan22@08_24_40, 2022-01-03 14:15:50.000000, 2022-01-03 14:00:50.000000, URS17005, EGA-03Jan22@09_00_50, 2022-01-03 14:42:00.000000
  QuestDB version 8.2.1
  2022-01-03 14:00:50.000000, URS17005, EGA-03Jan22@09_00_50, 2022-01-03 14:42:00.000000
  ERROR:  undefined bind variable: 4
  LINE 1: ...ity" = $2 AND "events"."start_ts" BETWEEN $3 AND $4 LIMIT $5
                                                                       ^
  ERROR:  undefined bind variable: 0
  LINE 1: ...T "events".* FROM "events" WHERE "events"."name" IN ($1, $2)
  ```

* psycopg included for comparison, but strangely it only throws error for the IN clause bind variable, not the LIMIT

  ```
  pip install -r requirements.txt && ./test_case.py
  ```

* result:

  ```
  QuestDB version 8.1.4
  executing with LIMIT bind variable
  (datetime.datetime(2022, 1, 3, 14, 0, 50), 'URS17005', 'EGA-03Jan22@09_00_50', datetime.datetime(2022, 1, 3, 14, 42))
  executing with IN bind variable
  (datetime.datetime(2022, 1, 3, 13, 24, 40), 'URS17006', 'EGA-03Jan22@08_24_40', datetime.datetime(2022, 1, 3, 14, 15, 50))
  (datetime.datetime(2022, 1, 3, 14, 0, 50), 'URS17005', 'EGA-03Jan22@09_00_50', datetime.datetime(2022, 1, 3, 14, 42))
  QuestDB version 8.2.1
  executing with LIMIT bind variable
  (datetime.datetime(2022, 1, 3, 14, 0, 50), 'URS17005', 'EGA-03Jan22@09_00_50', datetime.datetime(2022, 1, 3, 14, 42))
  executing with IN bind variable
  Traceback (most recent call last):
    File ".../questdb_prepared_statements/./test_case.py", line 32, in <module>
      cur.execute(IN_ERROR_SQL, IN_BINDS)
    File "...pyenv/versions/3.12.2/lib/python3.12/site-packages/psycopg/cursor.py", line 97, in execute
      raise ex.with_traceback(None)
  psycopg.DatabaseError: undefined bind variable: 0
  LINE 1: ...T "events".* FROM "events" WHERE "events"."name" IN ($1, $2)
  ```

* results with `pg.legacy.mode.enabled=true`


 ```

  $> ./test_case.rb

  QuestDB version 8.1.4
  2022-01-03 14:00:50.000000, URS17005, EGA-03Jan22@09_00_50, 2022-01-03 14:42:00.000000
  2022-01-03 13:24:40.000000, URS17006, EGA-03Jan22@08_24_40, 2022-01-03 14:15:50.000000, 2022-01-03 14:00:50.000000, URS17005, EGA-03Jan22@09_00_50, 2022-01-03 14:42:00.000000
  QuestDB version 8.2.1
  2022-01-03 14:00:50.000000, URS17005, EGA-03Jan22@09_00_50, 2022-01-03 14:42:00.000000
  2022-01-03 14:00:50.000000, URS17005, EGA-03Jan22@09_00_50, 2022-01-03 14:42:00.000000
  2022-01-03 13:24:40.000000, URS17006, EGA-03Jan22@08_24_40, 2022-01-03 14:15:50.000000, 2022-01-03 14:00:50.000000, URS17005, EGA-03Jan22@09_00_50, 2022-01-03 14:42:00.000000

  $> ./test_case.py

  QuestDB version 8.1.4
  executing with LIMIT bind variable
  (datetime.datetime(2022, 1, 3, 14, 0, 50), 'URS17005', 'EGA-03Jan22@09_00_50', datetime.datetime(2022, 1, 3, 14, 42))
  executing with IN bind variable
  (datetime.datetime(2022, 1, 3, 13, 24, 40), 'URS17006', 'EGA-03Jan22@08_24_40', datetime.datetime(2022, 1, 3, 14, 15, 50))
  (datetime.datetime(2022, 1, 3, 14, 0, 50), 'URS17005', 'EGA-03Jan22@09_00_50', datetime.datetime(2022, 1, 3, 14, 42))
  QuestDB version 8.2.1
  executing with LIMIT bind variable
  (datetime.datetime(2022, 1, 3, 14, 0, 50), 'URS17005', 'EGA-03Jan22@09_00_50', datetime.datetime(2022, 1, 3, 14, 42))
  executing with IN bind variable
  (datetime.datetime(2022, 1, 3, 13, 24, 40), 'URS17006', 'EGA-03Jan22@08_24_40', datetime.datetime(2022, 1, 3, 14, 15, 50))
  (datetime.datetime(2022, 1, 3, 14, 0, 50), 'URS17005', 'EGA-03Jan22@09_00_50', datetime.datetime(2022, 1, 3, 14, 42))
 ```
