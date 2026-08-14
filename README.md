# Delivery Performance Analysis

End-to-end analysis of a food/parcel delivery dataset — data cleaning and KPI
generation in Python, KPI validation in SQL, and an interactive dashboard in
Power BI.

<img width="1118" height="741" alt="delivery_performance_dashboard_Screenshot pbix" src="https://github.com/user-attachments/assets/eff7a07a-f44f-4801-952d-a5a68700d423" />

## Project Overview

Raw delivery data (order, pickup, and drop timestamps, agent details, store
and drop coordinates, traffic, weather, and vehicle type) was cleaned,
validated, and analyzed to answer:

- How fast and how reliable are deliveries overall?
- Which vehicle, traffic, weather, and area conditions perform best/worst?
- How does delivery efficiency change with distance?
- Are these differences statistically significant, or just noise?

## Workflow

```
raw_delivery_data.csv
        │
        ▼
Python / pandas  →  cleaning, validation, KPI & statistical analysis
        │
        ▼
SQL (SQLite)     →  KPI queries re-built and cross-checked against pandas
        │
        ▼
Power BI         →  interactive dashboard for exploration
```

## Repository Structure

```
├── notebook/
│   └── delivery_data_cleaning_and_analysis.ipynb   # Full cleaning + KPI + stats pipeline
├── sql/
│   └── delivery_kpi_queries.sql                    # KPI queries against the cleaned table
├── powerbi/
│   └── delivery_performance_dashboard.pbix          # Interactive dashboard
├── data/
│   └── raw_delivery_data.csv                        # Original, uncleaned dataset
├── images/
│   └── dashboard_screenshot.png
└── README.md
```

## Data Cleaning

- Removed null values and duplicate records, with before/after row counts logged
- Trimmed leading/trailing whitespace from all text columns
- Validated latitude/longitude ranges; corrected sign-flip errors in
  `Store_Latitude`/`Drop_Latitude` after confirming the pattern against the
  dataset's known geography
- Identified and removed rows with invalid near-zero ("Null Island") coordinates
- Corrected midnight-rollover errors in `Order_to_Pickup_Minutes`
- Calculated `Distance_km` (geodesic) and `Speed_kmph` from cleaned coordinates
  and timestamps

## Key Performance Indicators

| Metric | Description |
|---|---|
| Total Deliveries | Total unique orders |
| On-Time Delivery Rate | % of orders at or below the median delivery time (SLA benchmark) |
| Average Delivery Time | Order-to-drop duration (includes pickup wait) |
| Average Distance | Geodesic distance, store to drop |
| Average Speed | Distance ÷ delivery time — an efficiency measure, not road speed |
| Average Agent Rating | Customer-facing satisfaction score |

Each KPI is also broken down by **Vehicle**, **Traffic**, **Weather**,
**Area**, **Age Group**, **Distance Bucket**, hour of day, day of week, and
month.

## Statistical Analysis

- Correlation matrix across `Delivery_Time`, `Speed_kmph`, `Distance_km`,
  and `Agent_Rating`
- Outlier detection (IQR method) on `Delivery_Time` and `Distance_km`
- Significance testing (Kruskal-Wallis) confirming that delivery time
  differences across Traffic and Weather conditions are statistically real

## Key Findings

- **On-time rate (~53%) is close to 50% by design** — the SLA benchmark used
  is the dataset's own median delivery time, so this reflects the definition
  of the benchmark rather than poor performance.
- **Speed generally increases with distance** — short trips are less
  efficient because fixed pickup-wait time dominates a small distance.
- **Jam and High traffic conditions show the lowest average speeds**,
  confirming the expected real-world impact of congestion.
- **Vehicle type has a smaller effect on efficiency than traffic and
  distance do** — scooters and vans perform similarly; motorcycles trail
  slightly, likely tied to route/pickup-wait differences rather than the
  vehicle itself.

## Dashboard

The Power BI dashboard (`powerbi/delivery_performance_dashboard.pbix`)
provides an interactive view of all KPIs above, with slicers for Month,
Area, Order Hour, and Status.

## Tools Used

- **Python**: pandas, geopy, scipy, matplotlib, seaborn
- **SQL**: SQLite (via SQLAlchemy)
- **Power BI**: DAX measures, Power Query, interactive visuals

## Notes / Known Limitations

- `Speed_kmph` reflects overall delivery efficiency (distance ÷ total
  delivery time, including pickup wait) rather than pure road/travel speed.
- The dataset has no agent identifier, so `Agent_Rating` analysis reflects
  delivery **conditions** (traffic, weather, vehicle), not individual agent
  performance.
