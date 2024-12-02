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

* psycopg included for comparison, but it does not throw an error

  ```
  pip install -r requirements.txt && ./test_case.py
  ```
