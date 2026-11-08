# Mobile_Sales_Analysis
Mobile sales analytics on 3,800+ transactions (2021–2024). Python (pandas, SQLAlchemy) cleans and loads data into MySQL, where 12 queries with aggregations and window functions analyze sales by month, city, brand and payment method. An interactive Power BI dashboard tracks KPIs: ₹769M sales, 19K units, 3,835 transactions.


I wanted to answer a simple question: **what actually drives mobile phone sales?** Which brands win, which cities buy the most, when do people spend, and how do they pay?

So I took about 3,800 mobile sales transactions, cleaned them with Python, stored them in MySQL, wrote SQL queries to dig into them, and built an interactive Power BI dashboard to tell the story visually.


## What's in this project

| Piece | What it does |
| **Python** | Reads the raw data, cleans it, builds proper dates, calculates total sales, and loads everything into MySQL |
| **MySQL** | Stores the data and answers business questions through 12 queries |
| **Power BI** | An interactive dashboard with KPIs, a city map, monthly trends and slicers |

## The data

- **3,835 transactions** from **October 2021 to October 2024**
- **5 brands:** Apple, Samsung, OnePlus, Vivo, Xiaomi
- **19 Indian cities**, 4 payment methods (UPI, Credit Card, Debit Card, Cash)
- Columns: transaction ID, date parts, brand, mobile model, units sold, price per unit, customer name, age, city, payment method and rating

## Headline numbers

- **₹769M** total sales
- **19K** units sold
- **3,835** transactions
- **~₹40K** average price per unit

Sales are spread fairly evenly across the five brands, with Apple and Samsung slightly ahead.

# Questions the SQL queries answer

1. What are the overall KPIs (sales, quantity, transactions, average price)?
2. How do sales change month by month?
3. Which cities bring in the most revenue?
4. Which are the top 10 mobile models?
5. How are payments split across methods?
6. How does each brand perform?
7. How do customers rate their purchases?
8. Which day of the week sells the most?
9. What is the month-over-month growth?
10. What is the best-selling model within each brand?
11. How do sales differ across age groups?
The later queries use window functions (`LAG`, `RANK`, `SUM() OVER`) and CTEs. **They need MySQL 8.0 or newer.**

## Project structure

```
mobile-sales-analysis/
├── Mobile_Sales_Data.csv        # cleaned source data
├── mobile_sales_loader.py       # Python: clean + load into MySQL
├── mobile_sales_queries.sql     # 12 analysis queries
├── Mobile_Sales_Dashboard.pbix  # Power BI dashboard
└── images/
    └── dashboard.png
```

## How to run it yourself

**1. Install the packages**
```bash
pip install pandas sqlalchemy pymysql openpyxl
```

**2. Edit the config at the top of `mobile_sales_loader.py`**
```python
DB_USER = "root"
DB_PASS = quote_plus("your_password")   # quote_plus handles special characters like @
SOURCE_FILE = r"path/to/Mobile_Sales_Data.csv"
```

**3. Run the loader**
```bash
python mobile_sales_loader.py
```
This creates the `mobile_sales_db` database and the `sales_data` table, then loads the rows.

**4. Run the queries** in MySQL Workbench by opening `mobile_sales_queries.sql`.

**5. Connect Power BI**
Go to *Get data → MySQL database*, enter `localhost` and `mobile_sales_db`, and load the `vw_sales_dashboard` view.

##  Tools used

Python (pandas, SQLAlchemy, PyMySQL) · MySQL 8 · MySQL Workbench · Power BI · DAX

## What I learned

- Real data is messy. My day names were a mix of "Sat" and "Saturday", and there was no single date column, so I had to build one.
- Passwords with special characters like `@` can silently break a database connection string.
- Window functions make questions like "top brand per city" much cleaner than self-joins.
- Building the dashboard first and the SQL second showed me how much the two need to agree. Matching the dashboard's totals was my best check that the pipeline was right.

## What's next

- Year-over-year trends instead of combining all years into one Jan–Dec view
- Customer segmentation by age and rating
- Automating the pipeline so new data loads on a schedule


Thanks for checking this out if you have feedback or ideas, feel free to open an issue or reach out. 
