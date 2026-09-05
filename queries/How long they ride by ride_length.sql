 SELECT
  COUNT(*)/1000 AS rides_in_thousands,
  CAST(FLOOR(ride_length_minutes / 5) * 5 AS INT64) AS length_bucket,
  member_casual
FROM `bikeproject-507408.2024Data.ride_data_clean1`
GROUP BY length_bucket,member_casual
ORDER BY length_bucket

-- How long they ride by ride_length