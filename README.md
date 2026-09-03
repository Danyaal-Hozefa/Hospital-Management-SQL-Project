# Healthcare Analytics SQL Project

A MySQL-based healthcare analytics project designed to demonstrate database design, data management, and analytical SQL skills using a realistic hospital/healthcare dataset.

## Project Overview

This project builds a relational healthcare database containing departments, doctors, patients, appointments, bills, and medications. It then uses SQL queries to answer practical business and operational questions related to patient activity, doctor performance, departmental revenue, billing, medications, and appointments.

The project is suitable as a portfolio SQL project for demonstrating practical MySQL skills.

## Database Structure

The main database is **`Healthcare_Analytics_DB`**.

| Table | Records | Purpose |
|---|---:|---|
| `departments` | 25 | Hospital departments and operational information |
| `doctors` | 300 | Doctor profiles, specializations, experience, and status |
| `patients` | 500 | Patient demographic and healthcare information |
| `appointments` | 500 | Patient-doctor appointments and diagnoses |
| `bills` | 500 | Billing, payments, discounts, and insurance information |
| `medications` | 500 | Prescribed medications and treatment details |

The schema includes primary keys, foreign keys, indexes, constraints, default values, and ENUM fields. The main relationships connect doctors with departments, patients with doctors, and appointments/bills/medications with their related records.

## SQL Concepts Demonstrated

This project covers a broad range of SQL concepts:

- Database and table creation
- DDL and DML
- Primary keys and foreign keys
- Constraints and default values
- Indexing
- `SELECT`, `WHERE`, `ORDER BY`, and `LIMIT`
- String functions such as `CONCAT()`
- Aggregate functions: `COUNT()`, `SUM()`
- `GROUP BY`
- `HAVING` / filtering aggregated results
- `INNER JOIN` and `LEFT JOIN`
- Subqueries
- Window functions
- `DENSE_RANK()`
- Common Table Expressions (CTEs)
- Views
- `UPDATE` statements
- `COALESCE()`
- Triggers
- Data validation and verification steps

## Key Analysis Questions

The query file contains 12 practical SQL tasks, including:

1. Finding the first 10 patients from Bengaluru
2. Identifying active doctors with more than 10 years of experience
3. Counting patients treated by each doctor
4. Analyzing paid bills by payment mode
5. Finding the top 5 departments by paid revenue
6. Creating a doctor revenue view and identifying doctors above a revenue threshold
7. Finding the top 5 patients by total amount paid
8. Finding medications prescribed by doctors in departments containing "ology"
9. Ranking the top 3 earning patients within each city using a window function
10. Updating discounts for pending bills with a check-preview-update-verify workflow
11. Using a CTE to identify doctors with more than 8 appointments and creating a trigger for automatic discounts
12. Demonstrating DDL by creating a separate training database and related test tables

## Project Files

```text
healthcare-analytics-sql-project/
│
├── 01_healthcare_analytics_schema.sql
├── 02_healthcare_analytics_queries.sql
└── README.md
```

### `01_healthcare_analytics_schema.sql`

Creates the `Healthcare_Analytics_DB` database, defines the six main tables, creates indexes and relationships, and loads the project data.

### `02_healthcare_analytics_queries.sql`

Contains the analytical and database-management tasks, including joins, aggregations, window functions, CTEs, views, updates, triggers, and DDL examples.

## How to Run

### Prerequisites

- MySQL 8.0+ recommended
- MySQL Workbench, MySQL CLI, or another MySQL-compatible client

### Step 1 — Create the database and load the data

Run:

```sql
SOURCE 01_healthcare_analytics_schema.sql;
```

Or open the file in MySQL Workbench and execute it.

### Step 2 — Run the analysis queries

After the schema/data script has completed, run:

```sql
SOURCE 02_healthcare_analytics_queries.sql;
```

You can also execute individual questions from the query file to inspect each result separately.

## Important Notes

- The schema script recreates `Healthcare_Analytics_DB` using `DROP DATABASE IF EXISTS`, so running it again will replace the existing project database.
- The query file contains an update operation for pending bills and a trigger creation statement. Review these sections before running them on a database you care about.
- The final DDL section creates a separate `Hospital_Training_DB` database and switches the active database to it.
- The dataset is synthetic/generated data and should not be treated as real patient information.

## Skills Highlighted

**MySQL | SQL | Database Design | Data Analysis | Joins | Aggregations | Window Functions | CTEs | Views | Triggers | DDL | DML**

## Author

**Danyaal**

A portfolio project demonstrating practical SQL and relational database skills.
