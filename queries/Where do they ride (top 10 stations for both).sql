SELECT
  rides_in_thousands,
  start_station_name,
  member_casual
FROM (
  SELECT
    COUNT(*)/1000 AS rides_in_thousands,
    start_station_name,
    member_casual
  FROM `bikeproject-507408.2024Data.ride_data_clean1`
  WHERE start_station_name IS NOT NULL
  GROUP BY member_casual, start_station_name
  QUALIFY ROW_NUMBER() OVER (PARTITION BY member_casual ORDER BY COUNT(*) DESC) <= 10
)
ORDER BY member_casual, rides_in_thousands DESC

-- Where do they ride (top 10 stations of both casual and members)