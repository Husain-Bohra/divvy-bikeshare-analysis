# import glob
# from google.cloud import bigquery
# import pandas as pd

# client=bigquery.Client()
# table_id ="bikeproject-507408.2024Data.ride_data"

# csv_files= glob.glob("*.csv")
# df_list = [pd.read_csv(file) for file in csv_files]

# combined_df = pd.concat(df_list, ignore_index=True)

# job_config = bigquery.LoadJobConfig(
#     write_disposition=bigquery.WriteDisposition.WRITE_APPEND
# )

# job= client.load_table_from_dataframe(combined_df, table_id, job_config=job_config)

# print(f"Loaded {len(combined_df)} rows into {table_id}.")





"""
Load all Divvy monthly CSVs into a single BigQuery table.
 
Loads files directly (no pandas), one at a time, so memory usage stays
low even with many months of data. First file creates the table
(if it doesn't exist) using schema auto-detect; subsequent files append.
"""
 
import glob
from google.cloud import bigquery
 
# ---- Config ----
PROJECT_ID = "bikeproject-507408"
DATASET_ID = "2024Data"
TABLE_NAME = "ride_data"
CSV_FOLDER = "/home/husain/Desktop/datascience_conda/Project-DA/bikes/remaining_data"  # folder containing your CSVs, "." = current folder
# -----------------
 
table_id = f"{PROJECT_ID}.{DATASET_ID}.{TABLE_NAME}"
 
client = bigquery.Client(project=PROJECT_ID)
 
csv_files = sorted(glob.glob(f"{CSV_FOLDER}/*.csv"))
if not csv_files:
    raise SystemExit("No CSV files found — check CSV_FOLDER path.")
 
print(f"Found {len(csv_files)} CSV files to load.")
 
job_config = bigquery.LoadJobConfig(
    source_format=bigquery.SourceFormat.CSV,
    skip_leading_rows=1,       # skip header row
    autodetect=True,           # infer schema from first file
    write_disposition=bigquery.WriteDisposition.WRITE_APPEND,
)
 
total_rows = 0
 
for i, file_path in enumerate(csv_files, start=1):
    print(f"[{i}/{len(csv_files)}] Loading {file_path} ...")
 
    with open(file_path, "rb") as f:
        load_job = client.load_table_from_file(f, table_id, job_config=job_config)
 
    load_job.result()  # waits for the job to finish before moving to next file
 
    print(f"  Done — job loaded {load_job.output_rows} rows.")
    total_rows += load_job.output_rows
 
print(f"\nAll files loaded. Total rows added this run: {total_rows}")
 
table = client.get_table(table_id)
print(f"Table {table_id} now has {table.num_rows} total rows.")
 
