# dbt Ad Analytics

Proyecto de portfolio personal usando dbt + DuckDB para analizar
performance de campañas publicitarias en redes sociales.

## Dataset
- **Fuente:** Kaggle — Social Media Advertisement Performance
- **Link:** https://www.kaggle.com/datasets/alperenmyung/social-media-advertisement-performance
- **Tablas:** Users, Campaigns, Ads, Ad Events

## Stack
| Herramienta | Uso |
|-------------|-----|
| Python 3.x  | Entorno base |
| dbt-core    | Transformaciones |
| dbt-duckdb  | Adaptador local |
| DuckDB      | Base de datos local |
| kagglehub   | Descarga del dataset |

## Estructura
\`\`\`
01_dbt_ad_analytics/
├── README.md
├── data/          # CSVs del dataset (no se sube a Git)
├── models/        # Transformaciones SQL
├── seeds/         # Datos de referencia
├── tests/         # Tests de calidad
└── dbt_project.yml
\`\`\`