-- CREATE TABLE new_table AS 
-- SELECT column1, column2 
-- FROM existing_table;

-- FROM `bikeproject-507408.2024Data.ride_data`

-- `project_id.dataset_id.new_table_name`
CREATE TABLE `bikeproject-507408.2024Data.ride_data_clean1` AS
SELECT ride_id,rideable_type,
       started_at,ended_at,
       start_station_id,
       start_station_name,
       start_lat,
       start_lng,
       end_station_id,
       end_station_name,
       end_lat,
       end_lng,
       member_casual,
       EXTRACT(DAYOFWEEK FROM started_at) as day_of_week,
       TIMESTAMP_DIFF(ended_at,started_at,MINUTE) as ride_length_minutes

FROM `bikeproject-507408.2024Data.ride_data` 

WHERE 
       EXTRACT(YEAR FROM started_at ) = 2024 AND
       TIMESTAMP_DIFF(ended_at,started_at,MINUTE)>=1 AND
       TIMESTAMP_DIFF(ended_at,started_at,MINUTE)<1440 
       

QUALIFY ROW_NUMBER() OVER (PARTITION BY ride_id ORDER BY started_at) = 1


