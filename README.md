# Olist E-commerce Analytics Project

## Overview
This project analyzes transactional data from the Olist Brazilian e-commerce marketplace using SQL. The analysis focuses on understanding customer behavior, revenue distribution, product performance, and seller efficiency to support data-driven business decisions.

## Tools
- SQL (PostgreSQL-style syntax)
- Power BI (visualization and reporting)

### Data Exploration
Initial queries were used to understand dataset size by checking row counts across all tables and validating key relationships between customers, orders, and order items.

### Data Cleaning
Data quality checks identified missing foreign keys and duplicate customer records. Duplicate entries were removed using CTEs and window functions to ensure each customer was uniquely represented before analysis.

### Analysis
The final script focuses on business insights, including:
- Delivered orders analysis
- Total revenue and average order value (AOV)
- Orders per customer
- Customer lifetime value (LTV)
- Revenue concentration across top customers
- Top product categories by revenue
- High-value, low-volume products
- Top sellers by revenue
- Freight cost impact on seller performance

## Key Findings
- Revenue is highly concentrated among a small segment of customers
- Certain product categories consistently drive the majority of sales
- Some sellers experience high freight costs relative to product price
- High-priced products often sell in lower volumes but contribute strong margins

## Author
**Grace Joachim**  
Data Analyst
