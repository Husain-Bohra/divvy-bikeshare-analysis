SELECT 
  COUNT(*) AS rides_in_thousands ,EXTRACT(Hour FROM started_at) as hour,rideable_type
  

FROM `bikeproject-507408.2024Data.ride_data_clean1`

GROUP BY Hour,rideable_type
ORDER BY Hour ASC

-- Just trying to find anamoly maybe rideable type is related to Hour