-- Where do they ride by member type, assuming casual near parks and member near business districts
SELECT 

  COUNT(*)/1000 AS rides_in_thousands,
  start_station_name,
  member_casual

FROM `bikeproject-507408.2024Data.ride_data_clean1`
WHERE member_casual="casual" AND start_station_name IS NOT NULL
GROUP BY member_casual,start_station_name
ORDER BY rides_in_thousands DESC
LIMIT 10

-- had to remove null values sadly  , even after the fact that almost 1.2 million rides have null station names


-- ps- this created a problem as there 1390 distinct stations man, that's crazy