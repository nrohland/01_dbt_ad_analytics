import duckdb
import os

# Conexión a DuckDB
conn = duckdb.connect("dev.duckdb")

# Carpeta con los CSVs
data_path = os.path.join(os.path.dirname(__file__), "../data")

# Tablas a cargar
tables = {
    "raw_users": "users.csv",
    "raw_campaigns": "campaigns.csv",
    "raw_ads": "ads.csv",
    "raw_ad_events": "ad_events.csv",
}

# Crear schema raw y cargar cada CSV
conn.execute("CREATE SCHEMA IF NOT EXISTS raw")

for table, filename in tables.items():
    filepath = os.path.join(data_path, filename)
    conn.execute(f"""
        CREATE OR REPLACE TABLE raw.{table} AS 
        SELECT * FROM read_csv_auto('{filepath}')
    """)
    print(f"✅ Cargado: raw.{table}")

conn.close()
print("\n✅ Todos los datos cargados en DuckDB")