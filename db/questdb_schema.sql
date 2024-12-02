CREATE TABLE 'events' (
  start_ts TIMESTAMP,
  facility SYMBOL capacity 64 CACHE index capacity 64,
  name VARCHAR,
  end_ts TIMESTAMP
) timestamp (start_ts) PARTITION BY DAY WAL DEDUP UPSERT KEYS(start_ts, facility);
