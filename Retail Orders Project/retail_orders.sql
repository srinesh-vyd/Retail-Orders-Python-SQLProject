use srineshdb;
select * from retail_orders;

# 1. Find top 10 highest revenue generating products?
with cte as (select product_id, 
sum(sale_price) as revenue,
dense_rank() over(order by sum(sale_price) desc) as ranking
from retail_orders
group by product_id)
select product_id,revenue from cte where ranking <=10;
# or 
select product_id,sum(sale_price) as revenue
from retail_orders
group by product_id
order by revenue desc
limit 10;

# 2. Find top 5 highest selling products in each region?
with cte as (select region,product_id,
sum(quantity) as total_quantity,
rank() over(partition by region order by sum(quantity) desc) as ranking
from retail_orders
group by 1,2)
select region,product_id,total_quantity,ranking
from cte
where ranking<6;

# 3. find month over month growth comparision for 2022 and 2023 sales. Ex. Jan 2022 vs Jan 2023
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

# 4. For each category which month has highest sales?
select category,revenue,month
from (select date_format(order_date, '%Y-%m') as month,category,
sum(sale_price) as revenue,
rank() over(partition by category order by sum(sale_price) desc) as rnk
from retail_orders
group by 1,2) t
where rnk<2;

# 5. Which sub category had highest growth by profit in 2023 compare to 2022?
with cte as (select year(order_date) as year,sub_category,sum(profit) total_profit
from retail_orders
group by 1,2),
cte2 as (select sub_category,
sum(case
when year=2023 then total_profit
else 0
end) as profit_2023,
sum(case
when year=2022 then total_profit
else 0
end) as profit_2022
from  cte
group by 1)
select sub_category, ((profit_2023-profit_2022)*100/profit_2022) as profit_growth_percentage
from cte2
order by profit_growth_percentage desc
limit 1;