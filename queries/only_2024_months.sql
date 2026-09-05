SELECT
  FORMAT_TIMESTAMP('%Y-%m', started_at) AS month,
  COUNT(*) AS `rows`
FROM `bikeproject-507408.2024Data.ride_data`
WHERE EXTRACT(YEAR FROM started_at ) = 2024
GROUP BY month
ORDER BY month DESC