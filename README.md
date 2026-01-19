# Cyclistic Bike-Share User Analysis (2024)

## Project Overview
This project analyzes bike-share usage data to understand how **casual riders** and **annual members** use Cyclistic bikes differently.  
The goal is to use these insights to identify opportunities to **convert casual riders into members**.

The analysis is based on the Cyclistic case study from the **Google Data Analytics Professional Certificate**, but the project was extended using SQL Server and Power BI to reflect real-world analytics workflows.

---

## Business Question
How do annual members and casual riders use Cyclistic bikes differently, and what insights can help increase membership conversion?

---

## Tools Used
- **Excel Power Query** – initial cleaning of raw monthly files  
- **SQL Server** – data loading, cleaning, transformation, and analysis views  
- **Power BI** – interactive dashboard and visual analysis  
- **GitHub** – version control and project documentation  

---

## Dataset
- Source: Cyclistic Bike-Share dataset (Google Data Analytics Professional Certificate)
- Format: 12 monthly Excel files
- Time period: One full year (2024)

---

## Project Workflow

### 1. Excel Power Query – Initial Cleaning
- Removed duplicate records  
- Trimmed and standardized text fields  
- Standardized datetime formats  
- Ensured consistent column names across all files  

The cleaned files were exported as CSVs for database loading.

---

### 2. SQL Server – Staging and Data Load
- Created a staging table with all columns stored as text
- Bulk imported all 12 monthly CSV files
- Used this layer only for ingestion and validation

---

### 3. SQL Server – Cleaning and Feature Engineering
- Converted data types using safe `TRY_CONVERT` logic
- Calculated ride duration in minutes
- Created analytical columns:
  - Ride month
  - Day of week and day name
  - Hour of day
  - Weekend indicator
- Removed invalid rides (negative duration or rides longer than 24 hours)

---

### 4. SQL Views – Analytics Layer
Created SQL views to serve as a semantic layer for Power BI:
- Dimension views for slicers
- A KPI summary view
- Analysis views for trends, time patterns, bike types, and stations

---

### 5. Power BI Dashboard
Power BI connects directly to the SQL views and presents:
- Key KPIs
- Monthly ride trends
- Member vs casual behavior comparison
- Hourly demand patterns
- Ride duration distribution
- Bike type usage
- Top start stations

---

## Key KPIs
- Total rides  
- Average ride duration  
- Peak hour  
- Peak day of week  
- Peak month  
- Most used bike type  
- Most popular start station  

---

## Key Insights
- Members mainly use bikes during commute hours, while casual riders ride more on weekends and afternoons  
- Casual riders take longer rides compared to members  
- Ride demand is highly seasonal, peaking in late summer  
- Electric bikes are the most popular, especially among casual riders  
- A small number of stations account for a large share of total rides  

---

## Business Recommendations
- Offer weekend or summer membership trials targeting casual riders  
- Use electric bikes as a membership incentive  
- Run promotions at high-traffic stations  
- Highlight cost savings for frequent long-duration riders  

---

<img width="1284" height="720" alt="Screenshot 2026-01-19 230632" src="https://github.com/user-attachments/assets/27d6ed85-7c4c-4902-bd7f-f9064da97623" />


