 SELECT
  COUNT(*) AS rides,
  CAST(FLOOR(ride_length_minutes / 5) * 5 AS INT64) AS length_bucket,
  rideable_type
FROM `bikeproject-507408.2024Data.ride_data_clean1`
GROUP BY length_bucket,rideable_type
ORDER BY length_bucket