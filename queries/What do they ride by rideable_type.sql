-- What do they ride by member type
SELECT 

  COUNT(*)/1000 AS rides_in_thousands,
  rideable_type,
  member_casual

FROM `bikeproject-507408.2024Data.ride_data_clean1`
GROUP BY rideable_type,member_casual
ORDER BY member_casual ASC , rideable_type