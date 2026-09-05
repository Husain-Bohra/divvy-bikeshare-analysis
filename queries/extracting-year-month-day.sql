SELECT 
  EXTRACT(YEAR FROM started_at) as Year,
  EXTRACT(MONTH FROM started_at) as Month,
  EXTRACT(DAYOFWEEK FROM started_at) as Day

  

FROM `bikeproject-507408.2024Data.ride_data`
LIMIT 100