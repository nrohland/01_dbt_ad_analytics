import duckdb
import os

conn = duckdb.connect("/Users/nicolasrohland/Documents/portfolio/01_dbt_ad_analytics/dev.duckdb")

exports_path = "/Users/nicolasrohland/Documents/portfolio/01_dbt_ad_analytics/exports"
os.makedirs(exports_path, exist_ok=True)

marts = [
    "mart_campaign_performance",
    "mart_conversion_funnel",
    "mart_user_behavior",
    "mart_analytics"
]

for mart in marts:
    df = conn.execute(f"SELECT * FROM main.{mart}").df()
    output_path = os.path.join(exports_path, f"{mart}.csv")
    df.to_csv(output_path, index=False)
    print(f"✅ Exportado: {mart}.csv ({len(df)} filas)")

conn.close()
print("\n✅ Todos los marts exportados")