SELECT
  COUNTIF(TIMESTAMP_DIFF(ended_at, started_at, MINUTE) < 1) AS under_1min,
  COUNT(*) AS total,
  ROUND(COUNTIF(TIMESTAMP_DIFF(ended_at, started_at, MINUTE) < 1 OR TIMESTAMP_DIFF(ended_at, started_at, MINUTE) >1440) / COUNT(*) * 100, 2) AS pct
FROM `bikeproject-507408.2024Data.ride_data`
WHERE started_at >= '2024-01-01' AND started_at < '2025-01-01'