-- Where do they ride by member type, assuming casual near parks and member near business districts
SELECT 

  COUNT(*)/1000 AS rides_in_thousands,
  start_station_name,
  member_casual

FROM `bikeproject-507408.2024Data.ride_data_clean1`
GROUP BY member_casual,start_station_name
ORDER BY start_station_name

-- purposefully not adding WHERE start_station_name IS NOT NULL because its a huge chunk and besides a major chunk of electric has no start station mentioned


-- ps- this created a problem as there 1390 distinct stations man, that's crazy