CREATE OR REPLACE TABLE `sapient-zodiac-465011-t1.cycle_data.cleaned_cyclistic_data` AS
SELECT
  *,
  TIMESTAMP_DIFF(ended_at, started_at, MINUTE) AS ride_duration_minutes,
  FORMAT_DATE('%A', DATE(started_at)) AS day_of_week,
  FORMAT_DATE('%Y-%m', DATE(started_at)) AS ride_month,
  FORMAT_DATE('%Y-%m-%d', DATE(started_at)) AS ride_date,
  EXTRACT(YEAR FROM started_at) AS ride_year,
  EXTRACT(WEEK FROM started_at) AS week_number,
  EXTRACT(HOUR FROM started_at) AS ride_hour,
  -- Roundtrip: check if start and end station names are the same
 IFNULL(start_station_name, '') = IFNULL(end_station_name, '') AS is_roundtrip,

  -- Duration bucket
  CASE
    WHEN TIMESTAMP_DIFF(ended_at, started_at, MINUTE) <= 5 THEN 'Short'
    WHEN TIMESTAMP_DIFF(ended_at, started_at, MINUTE) <= 20 THEN 'Medium'
    ELSE 'Long'
  END AS ride_duration_category
FROM
  `sapient-zodiac-465011-t1.cycle_data.cycle-data-yearly`
WHERE
  -- 1. Valid ride duration
  TIMESTAMP_DIFF(ended_at, started_at, MINUTE) BETWEEN 1 AND 1440

  -- 2. Essential fields must exist
  AND ride_id IS NOT NULL
  AND rideable_type IS NOT NULL
  AND started_at IS NOT NULL
  AND ended_at IS NOT NULL
  AND member_casual IS NOT NULL

  -- 3. Valid ride_id length
  AND LENGTH(ride_id) = 16

  -- 4. Classic bikes must have full station names
  AND NOT (
    rideable_type = 'classic_bike' AND 
    (start_station_name IS NULL OR end_station_name IS NULL)
  )

  -- 5. Electric bikes must have start station
  AND NOT (
    rideable_type = 'electric_bike' AND 
    start_station_name IS NULL
  )

  -- 6. Electric scooters must have at least some origin info
  AND NOT (
    rideable_type = 'electric_scooter' AND
    start_station_name IS NULL AND
    start_station_id IS NULL AND
    start_lat IS NULL AND
    start_lng IS NULL
  )

  -- 7. Electric scooters must have at least some destination info
  AND NOT (
    rideable_type = 'electric_scooter' AND
    end_station_name IS NULL AND
    end_station_id IS NULL AND
    end_lat IS NULL AND
    end_lng IS NULL
  )

  -- 8. Remove rows where ALL destination fields are missing
  AND NOT (
    end_station_name IS NULL AND
    end_station_id IS NULL AND
    end_lat IS NULL AND
    end_lng IS NULL
  )

  -- 9. Remove rows where ALL GPS coordinates are missing
  AND NOT (
    start_lat IS NULL AND
    start_lng IS NULL AND
    end_lat IS NULL AND
    end_lng IS NULL
  )

  -- 10. Remove rows where both origin and destination stations are missing
  AND NOT (
    start_station_name IS NULL AND
    start_station_id IS NULL AND
    end_station_name IS NULL AND
    end_station_id IS NULL
  );
