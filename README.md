# SQL-Data-Analytics-Capstone-Case-Study
## Bike-Share capstone study (Cyclistic)

# Introduction and Background: 
### This project a capstone study through the Merit America- Google Data analytics course. 
The analysis focuses on using SQL to explore, clean, and model large-scale bike-share data in order to derive insights that support business decision-making.

---

## Tools: 
- **Excel**: Inspection, cleaning and preparation data
- **SQL** : Data transformation, agregation, and analytical querying

---

# Dataset
** The Cyclistic (Divvy) Bike-share Tripdata**
- Source : https://divvy-tripdata.s3.amazonaws.com/index.html
- License: https://divvybikes.com/data-license-agreement

The dataset consists of 12 months of publicly available bike-share trip data (2025), totaling over 5 million records. The data is provided *as-is* under the terms of the license agreement and is commonly used for educational and analytical purposes.

---

## ROCCC Data Validation
The dataset was evaluated using the ROCCC framework:

- **Reliable**: Provided by a recognized bike-share operator with consistent structure and documentation  
- **Original**: Primary source data published directly by the data owner  
- **Comprehensive**: Includes detailed trip-level attributes across a full 12-month period  
- **Current**: Covers trips from the most recent year available at the time of analysis (2025)  
- **Cited**: Data source and license are clearly documented  

----------------------------
## Business Task
This case study follows a hypothetical business scenario in which a bike-share company seeks to increase annual memberships.

**Primary Goal:**  
Understand how casual riders differ from annual members.

**Key Questions:**
- How do riding patterns differ between casual riders and members?
- What factors might influence a casual rider to purchase a membership?
- How could digital marketing strategies be informed by rider behavior?

## Limitations & Assumptions
- Casual riders use single-ride or full-day passes, while members hold annual subscriptions.
- Analysis is limited to variables available in the published dataset.
- No demographic or personally identifiable information is included.
- Findings are interpreted within the constraints of the provided schema and should not be treated as causal.

---

## Core Dataset Fields
- `member_casual`  
- `rideable_type`  
- `start_station_name`, `start_station_id`  
- `end_station_name`, `end_station_id`  
- `start_lat`, `start_lng`  
- `end_lat`, `end_lng`

## Project Scope
This repository focuses exclusively on **SQL-based analysis**, including data modeling and analytical querying.  
Exploratory analysis and visualization using R are documented separately and linked where applicable.


