SELECT
COUNTIF(TIMESTAMP_DIFF(ended_at,started_at,MINUTE)<1) AS less_one_min,
count(*) AS total_rows,
round((COUNTIF(TIMESTAMP_DIFF(ended_at,started_at,MINUTE)<1 OR TIMESTAMP_DIFF(ended_at,started_at,MINUTE)>1440 )/ count(*))*100 , 2) AS percent

FROM `bikeproject-507408.2024Data.ride_data` LIMIT 1000