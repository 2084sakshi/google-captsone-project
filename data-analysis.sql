SELECT * 
FROM
  `sapient-zodiac-465011-t1.cycle_data.rideable_type_summary`;

SELECT * ,
FROM
  `sapient-zodiac-465011-t1.cycle_data.cleaned_cyclistic_data`;

CREATE OR REPLACE TABLE `sapient-zodiac-465011-t1.cycle_data.ride_duration_summary` AS
SELECT
  member_casual,
  COUNT(*) AS ride_count,
  ROUND(AVG(ride_duration_minutes), 1) AS avg_duration_min,
  ROUND(APPROX_QUANTILES(ride_duration_minutes, 2)[OFFSET(1)], 1) AS median_duration_min,
  MIN(ride_duration_minutes) AS min_duration,
  MAX(ride_duration_minutes) AS max_duration
FROM
  `sapient-zodiac-465011-t1.cycle_data.cleaned_cyclistic_data`
GROUP BY member_casual;

CREATE OR REPLACE TABLE `sapient-zodiac-465011-t1.cycle_data.rides_by_day_summary` AS
SELECT
  day_of_week,
  member_casual,
  COUNT(*) AS ride_count
FROM
  `sapient-zodiac-465011-t1.cycle_data.cleaned_cyclistic_data`
GROUP BY day_of_week, member_casual;

CREATE OR REPLACE TABLE `sapient-zodiac-465011-t1.cycle_data.monthly_ride_summary` AS
SELECT
  ride_month,
  member_casual,
  COUNT(*) AS ride_count
FROM
  `sapient-zodiac-465011-t1.cycle_data.cleaned_cyclistic_data`
GROUP BY ride_month, member_casual
ORDER BY ride_month;

CREATE OR REPLACE TABLE `sapient-zodiac-465011-t1.cycle_data.rideable_type_summary` AS
SELECT
  member_casual,
  rideable_type,
  COUNT(*) AS ride_count
FROM
  `sapient-zodiac-465011-t1.cycle_data.cleaned_cyclistic_data`
GROUP BY member_casual, rideable_type;

CREATE OR REPLACE TABLE `sapient-zodiac-465011-t1.cycle_data.rides_by_hour_summary` AS
SELECT
  EXTRACT(HOUR FROM started_at) AS ride_hour,
  member_casual,
  COUNT(*) AS ride_count
FROM
  `sapient-zodiac-465011-t1.cycle_data.cleaned_cyclistic_data`
GROUP BY ride_hour, member_casual
ORDER BY ride_hour;

CREATE OR REPLACE TABLE `sapient-zodiac-465011-t1.cycle_data.roundtrip_summary` AS
SELECT
  member_casual,
  CASE 
    WHEN start_station_name = end_station_name AND start_station_name IS NOT NULL THEN 'Round Trip'
    ELSE 'One-Way'
  END AS trip_type,
  COUNT(*) AS ride_count
FROM
  `sapient-zodiac-465011-t1.cycle_data.cleaned_cyclistic_data`
GROUP BY member_casual, trip_type;

CREATE OR REPLACE TABLE `sapient-zodiac-465011-t1.cycle_data.duration_bucket_summary` AS
SELECT
  member_casual,
  CASE
    WHEN ride_duration_minutes <= 5 THEN '0-5 min'
    WHEN ride_duration_minutes <= 15 THEN '6-15 min'
    WHEN ride_duration_minutes <= 30 THEN '16-30 min'
    WHEN ride_duration_minutes <= 60 THEN '31-60 min'
    WHEN ride_duration_minutes <= 120 THEN '61-120 min'
    ELSE '120+ min'
  END AS duration_bucket,
  COUNT(*) AS ride_count
FROM
  `sapient-zodiac-465011-t1.cycle_data.cleaned_cyclistic_data`
GROUP BY member_casual, duration_bucket;

CREATE OR REPLACE TABLE `sapient-zodiac-465011-t1.cycle_data.top_start_stations_summary` AS
SELECT
  member_casual,
  start_station_name,
  COUNT(*) AS ride_count
FROM
  `sapient-zodiac-465011-t1.cycle_data.cleaned_cyclistic_data`
WHERE start_station_name IS NOT NULL
GROUP BY member_casual, start_station_name
ORDER BY member_casual, ride_count DESC;

CREATE OR REPLACE TABLE `sapient-zodiac-465011-t1.cycle_data.avg_duration_by_day_summary` AS
SELECT
  day_of_week,
  member_casual,
  ROUND(AVG(ride_duration_minutes), 1) AS avg_duration_min
FROM
  `sapient-zodiac-465011-t1.cycle_data.cleaned_cyclistic_data`
GROUP BY day_of_week, member_casual;

CREATE OR REPLACE TABLE `sapient-zodiac-465011-t1.cycle_data.bike_type_by_day_summary` AS
SELECT
  day_of_week,
  rideable_type,
  COUNT(*) AS ride_count
FROM
  `sapient-zodiac-465011-t1.cycle_data.cleaned_cyclistic_data`
GROUP BY day_of_week, rideable_type;

CREATE OR REPLACE TABLE `sapient-zodiac-465011-t1.cycle_data.map_start_summary` AS
SELECT
  member_casual,
  start_station_name,
  start_lat,
  start_lng,
  COUNT(*) AS ride_count
FROM
  `sapient-zodiac-465011-t1.cycle_data.cleaned_cyclistic_data`
WHERE start_station_name IS NOT NULL
GROUP BY member_casual, start_station_name, start_lat, start_lng;

CREATE OR REPLACE TABLE `sapient-zodiac-465011-t1.cycle_data.week_vs_weekend_summary` AS
SELECT
  member_casual,
  CASE
    WHEN FORMAT_DATE('%A', DATE(started_at)) IN ('Saturday', 'Sunday') THEN 'Weekend'
    ELSE 'Weekday'
  END AS day_type,
  COUNT(*) AS ride_count
FROM
  `sapient-zodiac-465011-t1.cycle_data.cleaned_cyclistic_data`
GROUP BY member_casual, day_type;

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






  

