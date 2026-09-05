SELECT COUNT(*)/1000 AS rides_in_thousands,member_casual,day_of_week FROM `bikeproject-507408.2024Data.ride_data_clean1`

GROUP BY member_casual,day_of_week
ORDER BY member_casual,day_of_week
LIMIT 1000