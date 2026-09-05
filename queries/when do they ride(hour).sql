SELECT COUNT(*)/1000 AS rides_in_thousands,member_casual,
       EXTRACT(Hour FROM started_at) as Hour,
       FROM `bikeproject-507408.2024Data.ride_data_clean1`

GROUP BY member_casual,EXTRACT(HOUR FROM started_at) 
ORDER BY member_casual,EXTRACT(HOUR FROM started_at) 
LIMIT 1000

-- When do they ride(hour)