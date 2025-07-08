--merge table
CREATE OR REPLACE TABLE
  `sapient-zodiac-465011-t1.cycle_data.cycle-data-yearly` AS
SELECT
  *
FROM
  `sapient-zodiac-465011-t1.cycle_data.2025-jan`
UNION ALL
SELECT
  *
FROM
  `sapient-zodiac-465011-t1.cycle_data.2025-feb`
UNION ALL
SELECT
  *
FROM
  `sapient-zodiac-465011-t1.cycle_data.2025-march`
UNION ALL
SELECT
  *
FROM
  `sapient-zodiac-465011-t1.cycle_data.2025-april`
UNION ALL
SELECT
  *
FROM
  `sapient-zodiac-465011-t1.cycle_data.2025-may`
UNION ALL
SELECT
  *
FROM
  `sapient-zodiac-465011-t1.cycle_data.2024-june`
UNION ALL
SELECT
  *
FROM
  `sapient-zodiac-465011-t1.cycle_data.2024-july`
UNION ALL
SELECT
  *
FROM
  `sapient-zodiac-465011-t1.cycle_data.2025-august`
UNION ALL
SELECT
  *
FROM
  `sapient-zodiac-465011-t1.cycle_data.2024-september`
UNION ALL
SELECT
  *
FROM
  `sapient-zodiac-465011-t1.cycle_data.2024-october`
UNION ALL
SELECT
  *
FROM
  `sapient-zodiac-465011-t1.cycle_data.2025-november`
UNION ALL
SELECT
  *
FROM
  `sapient-zodiac-465011-t1.cycle_data.2024-december`;

--check total rows
SELECT
  COUNT(*) AS total_combined_rows
FROM
  `sapient-zodiac-465011-t1.cycle_data.cycle-data-yearly`;
  SELECT
  SUM(row_count) AS total_monthly_rows
FROM (
  SELECT COUNT(*) AS row_count FROM `sapient-zodiac-465011-t1.cycle_data.2025-jan`
  UNION ALL
  SELECT COUNT(*) FROM `sapient-zodiac-465011-t1.cycle_data.2025-feb`
  UNION ALL
  SELECT COUNT(*) FROM `sapient-zodiac-465011-t1.cycle_data.2025-march`
  UNION ALL
  SELECT COUNT(*) FROM `sapient-zodiac-465011-t1.cycle_data.2025-april`
  UNION ALL
  SELECT COUNT(*) FROM `sapient-zodiac-465011-t1.cycle_data.2025-may`
  UNION ALL
  SELECT COUNT(*) FROM `sapient-zodiac-465011-t1.cycle_data.2024-june`
  UNION ALL
  SELECT COUNT(*) FROM `sapient-zodiac-465011-t1.cycle_data.2024-july`
  UNION ALL
  SELECT COUNT(*) FROM `sapient-zodiac-465011-t1.cycle_data.2025-august`
  UNION ALL
  SELECT COUNT(*) FROM `sapient-zodiac-465011-t1.cycle_data.2024-september`
  UNION ALL
  SELECT COUNT(*) FROM `sapient-zodiac-465011-t1.cycle_data.2024-october`
  UNION ALL
  SELECT COUNT(*) FROM `sapient-zodiac-465011-t1.cycle_data.2025-november`
  UNION ALL
  SELECT COUNT(*) FROM `sapient-zodiac-465011-t1.cycle_data.2024-december`
);

--- check count,diticnt count and null values
SELECT 'ride_id' AS column_name,
       COUNT(ride_id) AS total_rows,
       COUNT(DISTINCT ride_id) AS distinct_count,
       COUNTIF(ride_id IS NULL) AS null_count
FROM `sapient-zodiac-465011-t1.cycle_data.cycle-data-yearly`

UNION ALL

SELECT 'rideable_type',
       COUNT(rideable_type),
       COUNT(DISTINCT rideable_type),
       COUNTIF(rideable_type IS NULL)
FROM `sapient-zodiac-465011-t1.cycle_data.cycle-data-yearly`

UNION ALL

SELECT 'started_at',
       COUNT(started_at),
       COUNT(DISTINCT started_at),
       COUNTIF(started_at IS NULL)
FROM `sapient-zodiac-465011-t1.cycle_data.cycle-data-yearly`

UNION ALL

SELECT 'ended_at',
       COUNT(ended_at),
       COUNT(DISTINCT ended_at),
       COUNTIF(ended_at IS NULL)
FROM `sapient-zodiac-465011-t1.cycle_data.cycle-data-yearly`

UNION ALL

SELECT 'start_station_name',
       COUNT(start_station_name),
       COUNT(DISTINCT start_station_name),
       COUNTIF(start_station_name IS NULL)
FROM `sapient-zodiac-465011-t1.cycle_data.cycle-data-yearly`

UNION ALL

SELECT 'end_station_name',
       COUNT(end_station_name),
       COUNT(DISTINCT end_station_name),
       COUNTIF(end_station_name IS NULL)
FROM `sapient-zodiac-465011-t1.cycle_data.cycle-data-yearly`

UNION ALL

SELECT 'start_lat',
       COUNT(start_lat),
       COUNT(DISTINCT start_lat),
       COUNTIF(start_lat IS NULL)
FROM `sapient-zodiac-465011-t1.cycle_data.cycle-data-yearly`

UNION ALL

SELECT 'start_lng',
       COUNT(start_lng),
       COUNT(DISTINCT start_lng),
       COUNTIF(start_lng IS NULL)
FROM `sapient-zodiac-465011-t1.cycle_data.cycle-data-yearly`

UNION ALL

SELECT 'end_lat',
       COUNT(end_lat),
       COUNT(DISTINCT end_lat),
       COUNTIF(end_lat IS NULL)
FROM `sapient-zodiac-465011-t1.cycle_data.cycle-data-yearly`

UNION ALL

SELECT 'end_lng',
       COUNT(end_lng),
       COUNT(DISTINCT end_lng),
       COUNTIF(end_lng IS NULL)
FROM `sapient-zodiac-465011-t1.cycle_data.cycle-data-yearly`

UNION ALL

SELECT 'member_casual',
       COUNT(member_casual),
       COUNT(DISTINCT member_casual),
       COUNTIF(member_casual IS NULL)
FROM `sapient-zodiac-465011-t1.cycle_data.cycle-data-yearly`;

-- Count of ride_ids not having exactly 16 characters
SELECT
  COUNT(*) AS invalid_ride_ids
FROM
  `sapient-zodiac-465011-t1.cycle_data.cycle-data-yearly`
WHERE
  LENGTH(ride_id) != 16;

-- See all distinct bike types and how many times each occurs
SELECT
  rideable_type,
  COUNT(*) AS count
FROM
  `sapient-zodiac-465011-t1.cycle_data.cycle-data-yearly`
GROUP BY
  rideable_type
ORDER BY
  count DESC;

--count no of rides by member type
SELECT
  member_casual,
  COUNT(*) AS ride_count
FROM
  `sapient-zodiac-465011-t1.cycle_data.cycle-data-yearly`
GROUP BY
  member_casual
ORDER BY
  ride_count DESC;
---ride duration how many invalid
SELECT
  COUNT(*) AS total_rows,
  COUNTIF(TIMESTAMP_DIFF(ended_at, started_at, MINUTE) < 1) AS too_short,
  COUNTIF(TIMESTAMP_DIFF(ended_at, started_at, MINUTE) > 1440) AS too_long,
  MIN(TIMESTAMP_DIFF(ended_at, started_at, MINUTE)) AS min_duration,
  MAX(TIMESTAMP_DIFF(ended_at, started_at, MINUTE)) AS max_duration
FROM `sapient-zodiac-465011-t1.cycle_data.cycle-data-yearly`;

-- Start station: check nulls and most common values
SELECT
  COUNTIF(start_station_name IS NULL) AS null_start_names,
  COUNTIF(end_station_name IS NULL) AS null_end_names
FROM `sapient-zodiac-465011-t1.cycle_data.cycle-data-yearly`;

-- Top 10 start stations
SELECT start_station_name, COUNT(*) AS rides
FROM `sapient-zodiac-465011-t1.cycle_data.cycle-data-yearly`
GROUP BY start_station_name
ORDER BY rides DESC
LIMIT 10;

-- Top 10 start stations
SELECT end_station_name, COUNT(*) AS rides
FROM `sapient-zodiac-465011-t1.cycle_data.cycle-data-yearly`
GROUP BY end_station_name
ORDER BY rides DESC
LIMIT 10;

-- Check lat/lng missing or out of expected Chicago range
SELECT
  COUNTIF(start_lat IS NULL OR start_lng IS NULL) AS null_start_coords,
  COUNTIF(end_lat IS NULL OR end_lng IS NULL) AS null_end_coords,
  COUNTIF(start_lat NOT BETWEEN 41 AND 42 OR start_lng NOT BETWEEN -88 AND -87) AS invalid_start_coords,
  COUNTIF(end_lat NOT BETWEEN 41 AND 42 OR end_lng NOT BETWEEN -88 AND -87) AS invalid_end_coords
FROM `sapient-zodiac-465011-t1.cycle_data.cycle-data-yearly`;

-- Make sure all rides are between June 2024 – May 2025, and no nulls.
SELECT
  MIN(started_at) AS earliest_start,
  MAX(started_at) AS latest_start,
  MIN(ended_at) AS earliest_end,
  MAX(ended_at) AS latest_end,
  COUNTIF(started_at IS NULL OR ended_at IS NULL) AS null_timestamps
FROM `sapient-zodiac-465011-t1.cycle_data.cycle-data-yearly`;

--Analysis of Nulls in Lat/Long Columns
SELECT
  num_nulls,
  COUNT(*) AS row_count
FROM (
  SELECT
    -- Count how many of the 4 location fields are NULL in each row
    (IF(start_lat IS NULL, 1, 0) +
     IF(start_lng IS NULL, 1, 0) +
     IF(end_lat IS NULL, 1, 0) +
     IF(end_lng IS NULL, 1, 0)) AS num_nulls
  FROM
    `sapient-zodiac-465011-t1.cycle_data.cycle-data-yearly`
)
GROUP BY
  num_nulls
ORDER BY
  num_nulls;

SELECT
  num_nulls,
  COUNT(*) AS row_count
FROM (
  SELECT
    -- Count how many of the 13 columns are NULL for each row
    (
      IF(ride_id IS NULL, 1, 0) +
      IF(rideable_type IS NULL, 1, 0) +
      IF(started_at IS NULL, 1, 0) +
      IF(ended_at IS NULL, 1, 0) +
      IF(start_station_name IS NULL, 1, 0) +
      IF(end_station_name IS NULL, 1, 0) +
      IF(start_lat IS NULL, 1, 0) +
      IF(start_lng IS NULL, 1, 0) +
      IF(end_lat IS NULL, 1, 0) +
      IF(end_lng IS NULL, 1, 0) +
      IF(member_casual IS NULL, 1, 0) +
      IF(start_station_id IS NULL, 1, 0) +
      IF(end_station_id IS NULL, 1, 0)
    ) AS num_nulls
  FROM `sapient-zodiac-465011-t1.cycle_data.cycle-data-yearly`
)
GROUP BY num_nulls
ORDER BY num_nulls DESC;

--find combo of null column
SELECT
  COUNT(*) AS row_count,
  IF(ride_id IS NULL, 'NULL', 'OK') AS ride_id,
  IF(rideable_type IS NULL, 'NULL', 'OK') AS rideable_type,
  IF(started_at IS NULL, 'NULL', 'OK') AS started_at,
  IF(ended_at IS NULL, 'NULL', 'OK') AS ended_at,
  IF(start_station_name IS NULL, 'NULL', 'OK') AS start_station_name,
  IF(end_station_name IS NULL, 'NULL', 'OK') AS end_station_name,
  IF(start_lat IS NULL, 'NULL', 'OK') AS start_lat,
  IF(start_lng IS NULL, 'NULL', 'OK') AS start_lng,
  IF(end_lat IS NULL, 'NULL', 'OK') AS end_lat,
  IF(end_lng IS NULL, 'NULL', 'OK') AS end_lng,
  IF(member_casual IS NULL, 'NULL', 'OK') AS member_casual,
  IF(start_station_id IS NULL, 'NULL', 'OK') AS start_station_id,
  IF(end_station_id IS NULL, 'NULL', 'OK') AS end_station_id
FROM
  `sapient-zodiac-465011-t1.cycle_data.cycle-data-yearly`
GROUP BY
  ride_id,
  rideable_type,
  started_at,
  ended_at,
  start_station_name,
  end_station_name,
  start_lat,
  start_lng,
  end_lat,
  end_lng,
  member_casual,
  start_station_id,
  end_station_id
HAVING
  COUNT(*) > 10 -- Optional: skip very rare patterns
ORDER BY
  row_count DESC;

  --check rules

SELECT
  *,
  TIMESTAMP_DIFF(ended_at, started_at, MINUTE) AS ride_duration_minutes,
  FORMAT_DATE('%A', DATE(started_at)) AS day_of_week,
  FORMAT_DATE('%Y-%m', DATE(started_at)) AS ride_month
FROM
  `sapient-zodiac-465011-t1.cycle_data.cycle-data-yearly`
WHERE
  -- Keep valid durations
  TIMESTAMP_DIFF(ended_at, started_at, MINUTE) BETWEEN 1 AND 1440
  
  -- Remove rows missing both origin name + id
  --AND NOT (start_station_name IS NULL AND start_station_id IS NULL)
  
  -- Remove rows missing both destination name + id
  --AND NOT (end_station_name IS NULL AND end_station_id IS NULL)
  
  -- Remove rows missing ALL lat/lng (start and end)
  AND NOT (
    start_lat IS NULL AND start_lng IS NULL AND
    end_lat IS NULL AND end_lng IS NULL
  )
  
  -- Sanity check: ride_id must exist and be 16 characters
  AND ride_id IS NOT NULL AND LENGTH(ride_id) = 16
  AND rideable_type IS NOT NULL
  AND member_casual IS NOT NULL
  AND started_at IS NOT NULL
  AND ended_at IS NOT NULL;

  SELECT
  member_casual,
  start_station_name,
  COUNT(*) AS ride_count
FROM
  `sapient-zodiac-465011-t1.cycle_data.cleaned_cyclistic_data`
WHERE
  start_station_name IS NOT NULL
GROUP BY
  member_casual, start_station_name
ORDER BY
  member_casual, ride_count DESC
LIMIT 20;

SELECT
  member_casual,
  start_station_name,
  COUNT(*) AS round_trip_count
FROM
  `sapient-zodiac-465011-t1.cycle_data.cleaned_cyclistic_data`
WHERE
  start_station_name IS NOT NULL
  AND end_station_name IS NOT NULL
  AND start_station_name = end_station_name
GROUP BY
  member_casual, start_station_name
ORDER BY
  member_casual, round_trip_count DESC
LIMIT 20;











