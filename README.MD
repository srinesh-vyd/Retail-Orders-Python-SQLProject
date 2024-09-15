# Data Analysis Project Using SQL in MySQL
This project is a simple data analysis pipeline using a dataset from Kaggle. The dataset was downloaded via the Kaggle API, transformed using Python and Pandas, and loaded into a MySQL database. Finally, SQL queries were used to analyze the data.
## Table of Contents
1. [Project Overview](#project-overview)
2. [Technologies Used](#technology-used)
3. [Installation](#installation)
4. [Dataset](#dataset)
5. [Data Transformation](#data-transformation)
6. [SQL Analysis](#sql-analysis)
7. [Results](#results)
8. [License](#license)
9. [Contact](#contact)

## Project Overview
The goal of this project was to perform basic data analysis using SQL in a MySQL database. The process involved:

1. Downloading a dataset from Kaggle.
2. Loading the dataset into a Pandas DataFrame.
3. Cleaning and transforming the data.
4. Loading the transformed data into a MySQL database.
5. Analyzing the dataset using SQL queries.

## Technologies Used
- Python: Used for data extraction, transformation, and loading (ETL).
- Pandas: For data manipulation and cleaning.
- SQLAlchemy & PyODBC: For connecting to the MySQL database.
- MySQL: For storing and querying the dataset.
- Jupyter Notebook: For developing the entire workflow.
- Kaggle API: To download the dataset programmatically.

## Installation
### Prerequisites
Make sure the following are installed on your system:

- Python 3.x
- MySQL Database (Running locally or on a remote server)
- Jupyter Notebook (For running the notebook)
- Kaggle API: For dataset downloading

### Steps
1. Clone the repository
```bash
git clone https://github.com/srinesh-vyd/Retail-Orders-Python-SQLProject.git
cd Retail-Orders-Python-SQLProject
```
2. Create a new python environment
3. Open the retail_orders.ipynb notebook and follow the steps inside.
3. Install required Python libraries:
```jupyter
!pip install kaggle
import kaggle
```
4. Set up the Kaggle API:
      - Create a Kaggle account and generate an API token.
      - Place the API token file (kaggle.json) in the appropriate directory (~/.kaggle/ for Linux/Mac or C:\Users\YourUsername\.kaggle\ for Windows).
5. Create a MySQL database and configure the DSN (Data Source Name) for pyodbc. Update the notebook with your connection details.

## Datasets
The dataset used for this project was sourced from Kaggle. It was downloaded using the Kaggle API and saved as a CSV file.

### Steps to download the dataset:
Inside the Jupyter notebook, use the Kaggle API to download and extract the dataset:
```jupyter
!kaggle datasets download -d ankitbansal06/retail-orders
import zipfile
zip_ref=zipfile.ZipFile("retail-orders.zip")
zip_ref.extractall()
zip_ref.close()
```
After downloading, the dataset is extracted, loaded into a Pandas DataFrame, and prepared for further transformation.
## Data Transformation
Once the dataset was loaded into a Pandas DataFrame, the following transformations were applied:
1. Handling Missing Data: Missing values were identified. Values such as 'Not available' and 'unknown' were converted to nan.
2. Data Type Conversion: Ensured that columns had the correct data types (e.g., converting object type columns to datetime).
3. Renaming Columns: Some columns were renamed for clarity and consistency.
```
import pandas as pd
df=pd.read_csv("orders.csv",na_values=['Not Available', 'unknown'])
df.columns=df.columns.str.lower()
df.columns=df.columns.str.replace(' ','_')
df['order_date']=pd.to_datetime(df['order_date'])
```
## SQL Analysis
The cleaned and transformed dataset was loaded into a MySQL table using SQLAlchemy and PyODBC. After loading the data, several SQL queries were executed to analyze the dataset.
### Queries
1. What are the top 10 highest revenue generating products?
```mysql
with cte as (select product_id, 
sum(sale_price) as revenue,
dense_rank() over(order by sum(sale_price) desc) as ranking
from retail_orders
group by product_id)
select product_id,revenue from cte where ranking <=10;
```
2. What are the top 5 highest selling products in each region?
```mysql
with cte as (select region,product_id,
sum(quantity) as total_quantity,
rank() over(partition by region order by sum(quantity) desc) as ranking
from retail_orders
group by 1,2)
select region,product_id,total_quantity,ranking
from cte
where ranking<=5;
```
3. Find month over month growth comparision for 2022 and 2023 sales. Ex. Jan 2022 vs Jan 2023
```mysql
with revenue_2023 as (select extract(year from order_date) as year,extract(month from order_date) as month,
sum(sale_price) as revenue
from retail_orders
where extract(year from order_date)=2023
group by 1,2),
revenue_2022 as (select extract(year from order_date) as year,extract(month from order_date) as month,
sum(sale_price) as revenue
from retail_orders
where extract(year from order_date)=2022
group by 1,2)
select t23.month,t22.revenue as revenue_2022,
t23.revenue as revenue_2023,
(t23.revenue-t22.revenue)*100/t22.revenue as growth_percentage
from revenue_2023 t23
join revenue_2022 t22
on t23.month=t22.month
order by 1;
```
4. For each category which month has highest sales?
```mysql
select category,revenue,month
from (select date_format(order_date, '%Y-%m') as month,category,
sum(sale_price) as revenue,
rank() over(partition by category order by sum(sale_price) desc) as rnk
from retail_orders
group by 1,2) t
where rnk<2;
```
5. Which sub category had highest growth by profit in 2023 compare to 2022?
```sql
with cte as (select year(order_date) as year,sub_category,sum(profit) total_profit
from retail_orders
group by 1,2),
cte2 as (select sub_category,
sum(case when year=2023 then total_profit else 0 end) as profit_2023,
sum(case when year=2022 then total_profit else 0 end) as profit_2022
from  cte
group by 1)
select sub_category, ((profit_2023-profit_2022)*100/profit_2022) as profit_growth_percentage
from cte2
order by profit_growth_percentage desc
limit 1;
```
## Results
- The dataset was successfully cleaned and loaded into MySQL.
- Data analysis revealed valuable insights, such as the total revenue, profitable categories, and regional distribution of orders.
## License
This project is licensed under the MIT License. See the LICENSE file for more details.

## Contact
Created by Srinesh.vyd. The dataset is provided by Ankit Bansal. Feel free to contact me via GitHub for any questions or feedback.
