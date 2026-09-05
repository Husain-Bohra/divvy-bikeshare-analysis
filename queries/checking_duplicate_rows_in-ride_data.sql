-- SELECT COUNT(*)
-- FROM `bikeproject-507408.2024Data.ride_data`
-- WHERE ride_id IN (
--   SELECT ride_id
--   FROM `bikeproject-507408.2024Data.ride_data`
--   WHERE EXTRACT(YEAR FROM started_at) = 2024
--   GROUP BY ride_id
--   HAVING COUNT(*) > 1
-- )

-- LIMIT 50

-- SELECT
--   COUNT(*) AS total_rows,
--   COUNT(DISTINCT ride_id) AS distinct_ride_ids
-- FROM `bikeproject-507408.2024Data.ride_data`
-- WHERE EXTRACT(YEAR FROM started_at) = 2024








