# Divvy Bike-Share Case Study: Converting Casual Riders to Members

**Author:** Husain Bohra
**Tools used:** Python, Google BigQuery, SQL, Google Cloud CLI, pandas, matplotlib, Metabase (self-hosted via Docker)
**Data source:** [Divvy Trip Data](https://divvybikes.com/system-data) — 12 months of 2024 trip records, Chicago's public bike-share system

---

## 1. Business Task

Divvy earns more revenue from annual members than from casual (pay-per-ride) riders. The business question: **how do casual riders differ from members in behavior, and what would convert casual riders into members?**
This Case Study Uses the 6 phases of Analyst workflow Ask,Prepare,Process,Analyze,Share,Act
I will use vscode for Prepare phase, use BigQuery to Process, matplotlib and Metabase to Analyze and Github to Share and This document file to Recommend Future Actions

---

## 2. Data Extraction

Divvy publishes monthly trip data as zipped CSVs at `https://divvy-tripdata.s3.amazonaws.com/{YYYYMM}-divvy-tripdata.zip`.

- Wrote a Python script (`download_divvy_data.py`) to loop over a hardcoded date range and download all 12 months automatically, instead of manually fetching each file from the browser.
- Wrote a second script to bulk-unzip all downloaded files.
- **Probelem 1:** BigQuery's web console UI caps manual uploads at 100MB. A couple of the larger monthly files exceeded this, so early on I split those CSVs into two halves each and uploaded them separately (still mannual)
- **Solution:** I switched to loading files via the `google-cloud-bigquery` Python client instead of the console UI. The 100MB cap turned out to be a **console UI** limitation, not an API limitation. Now i could upload files of any size to bigquery

---

## 3. Google Cloud Authentication

This was not straightforward , using `bigquery.Client()` in python needs credentials, had to complete it even after a previous `authentication` that was for auth my CLI

- Since I was uploading **manully** in the start, some months were uploaded twice accidentally




---

## 4. Cleaning in BigQuery (Sandbox tier free account)

BigQuery's free Sandbox tier doesn't support `UPDATE`/`DELETE`/`MERGE` (DML) Standard BigQuery practice anyway.
It is easier to CREATE new_clean_table instead of ALTER old_talbe

**Cleaning steps applied, in order:**

1. **Date range fix** A monthly-breakdown query surfaced 14 distinct months instead of 12; the download script's range had overshot into early 2025. Fixed with `EXTRACT(YEAR FROM started_at) = 2024`.
2. **Invalid duration rows** Dropped rows where `ended_at <= started_at`.
3. **Duration outliers** Dropped trips under 1 minute (~2.18% of rows, verified by query, not assumed; this rate matches Divvy's own documented pattern of false-start/maintenance trips) and over 24 hours (bikes not properly docked).
4. **Duplicate `ride_id`s** Found ~1.43M duplicate rows (`total_rows` − `distinct ride_id count` = 7,292,096 − 5,860,357), traced to some months being loaded into BigQuery twice during the earlier manual-upload phase. Fixed using:
   ```sql
   QUALIFY ROW_NUMBER() OVER (PARTITION BY ride_id ORDER BY started_at) = 1
   ```
5. **Derived columns added:** `ride_length_minutes` using `TIMESTAMP_DIFF(ended_at,started_at)`) and `day_of_week` using `EXTRACT(DAYOFWEEK FROM started_at)`

**Result:** `ride_data_clean1` A verified, deduplicated, outlier-free table with 5.72M+ rows.


---

## 5. Analysis — Five Questions

Rather than searching for an arbitrary "interesting" pattern, analysis was structured around five specific behavioral axes comparing `member` vs `casual` riders:

1. **When do they ride (day of week)?** Members show a steady, mid-week-weighted pattern (commute shape). Casual riders peak on weekends.
2. **When do they ride (hour of day)?** Members show a clear bimodal 8am/5pm spike (commute pattern). Casual riders show one broad afternoon peak — the single clearest chart in the whole project.
3. **When do they ride (month)?** Casual ridership is highly seasonal, plunging in winter and peaking hard in summer. Member ridership stays comparatively steady year-round.
4. **How long do they ride?** Member rides cluster heavily in the 0-10 minute bucket. Casual riders show a proportionally longer tail toward 30+ minute rides.
5. **Where do they ride?** Top casual start stations (Streeter Dr & Grand Ave, DuSable Lake Shore Dr, Millennium Park, Shedd Aquarium, Adler Planetarium) are almost entirely lakefront tourist/recreational landmarks. Top member stations (Kingsbury & Kinzie, Clinton & Washington/Madison/Jackson, Clark & Elm) are downtown Loop/River North business-district intersections. This split was hypothesized before running the query and confirmed almost exactly.

**A structural limitation in the dataset:** Divvy's public data has no persistent rider ID, so there is no way to trace an individual casual rider becoming a member over time. This analysis cannot show conversion directly — it can only characterize the behavioral gap between the two groups and use that gap to infer what a conversion offer should look like.

---

## 6. Visualization Tooling — another round of friction

- **Tableau Public** (the free tier) does **not** support a live BigQuery connection, It is file-based only (CSV, Excel, Google Sheets, etc.), and Tableau Desktop has a proper BigQuery connector but is trial-only unless purchased.
- **Chose Metabase (self-hosted via Docker)** instead since it is free open-source,fee for self hosted users and a native BigQuery connector, no CSV export/import dance required.

  - Connecting BigQuery to Metabase required a **service account JSON key**  Third, distinct credential type from the two gcloud auth steps used earlier, since Metabase (a third-party app) needs its own service identity rather than acting as the logged-in user.

---

## 7. Dashboard Build Notes

- Metabase's chart builder auto-assigns axis roles from column types and sometimes guesses wrong (e.g., treating a second numeric column as a value to sum rather than a category to group by) — fields need to be manually assigned to X-axis / Y-axis / "group by" (series breakout) roles.
- SQL month numbers and length-bucket labels both needed a companion "sort key" column (`month_num`, `bucket_order`) so Metabase would display readable labels (`"January"`, `"0-10"`) while still sorting in the correct logical order rather than alphabetically.
- The 1,390-distinct-station chart was unplottable as a bar chart at full granularity — fixed using ```sql
QUALIFY ROW_NUMBER() OVER (PARTITION BY member_casual ORDER BY COUNT(*) DESC) <= 10```
- To get the top 10 stations **per rider type**, not overall.
- Metabase's free pin-map visualization doesn't support color-coding or sizing markers by a field due to feature limitation. Worked around it by building two separate maps (casual stations / member stations) side-by-side rather than one combined overlay.

---

## 8. Key Findings (Summary)

Members and casual riders are not the same customer type of Customers, They are using the service for two different purposes:

- **Members ride like commuters:** short, steady, weekday, bimodal peak hours, stable across seasons, concentrated at downtown business-district stations.
- **Casual riders ride like tourists/recreational users:** longer, weekend-skewed, highly seasonal (collapsing in winter), concentrated at lakefront landmark stations.

---

## 9. Recommendation

**Introduce a summer-season, weekend-exclusive, long-duration pass** priced for recreational use rather than daily commuting, and **advertise it directly at the casual-rider hotspots identified in the station analysis** Specifically Adler Planetarium, Millennium Park, Shedd Aquarium, and Streeter Dr & Grand Ave, where casual ridership is heavily concentrated.

The reasoning: a casual rider isn't "A potential full time member"  they often don't have a commuting use case at all, so the standard annual membership (priced and marketed around daily use) is a poor value proposition for them. A seasonal/weekend product matches the membership offer to the behavior the data actually shows, rather than asking casual riders to adopt a product built for a different kind of rider.

---

## 10. What I'd Do Differently Next Time

- Use automated data gathering scripts
- Use Self Hosted free Open-Source Metabase for BI Visualtion

