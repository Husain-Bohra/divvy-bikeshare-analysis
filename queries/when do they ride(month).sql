SELECT COUNT(*)/1000 AS rides_in_thousands,member_casual,
       EXTRACT(MONTH FROM started_at) as month,
       FROM `bikeproject-507408.2024Data.ride_data_clean1`

GROUP BY member_casual,EXTRACT(MONTH FROM started_at) 
ORDER BY member_casual,EXTRACT(MONTH FROM started_at) 
LIMIT 1000