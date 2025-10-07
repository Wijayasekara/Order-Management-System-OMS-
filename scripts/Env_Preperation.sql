/*
====================================================================================
OMS Data Architecture Overview
====================================================================================

The OMS database follows a **three-layer architecture**: **Bronze**, **Silver**, and **Gold**.
Each layer serves a distinct purpose in the data processing and transformation pipeline.

1️**Bronze Layer (Raw Layer)**
   - This is the *landing zone* for raw data.
   - Data from the source files (CSV, APIs, etc.) is loaded here *as-is*, without any transformation.
   - Each source file maps directly to a table (one table per file).
   - Column names and structures match the original source exactly.
   - Purpose: To preserve the original data for traceability and audit.

2️**Silver Layer (Cleaned & Enriched Layer)**
   - This layer is used for *data cleaning, validation, and light transformation*.
   - The table structures remain the same as in the Bronze layer (no schema changes).
   - Data corrections, standardization, and basic enrichment are applied here 
     (e.g., fixing data types, removing duplicates, handling nulls, ensuring referential integrity).
   - Purpose: To prepare high-quality, analysis-ready data while retaining the original schema.

3️ **Gold Layer (Business / Presentation Layer)**
   - This is the *business-facing* layer designed for analytics and reporting.
   - Data from the Silver layer is modeled into a **Star Schema** or **Dimensional Model** 
     with clearly defined **Fact** and **Dimension** tables.
   - Additional **views**, **aggregations**, and **metrics** are created to support business users and BI tools.
   - Purpose: To enable performant and user-friendly access to curated business data.

------------------------------------------------------------------------------------
Summary:
Bronze → Raw data  
Silver → Cleaned and validated data  
Gold → Business-ready, analytics-focused data model (Star Schema + Views)
------------------------------------------------------------------------------------
*/


-- Create the 3 schemas as "Bronze", "Silver" and "Gold"
CREATE SCHEMA bronze;
CREATE SCHEMA silver;
CREATE SCHEMA gold;

SET SEARCH_PATH TO bronze;

-- drop the default schema which is 'public'
DROP SCHEMA public
