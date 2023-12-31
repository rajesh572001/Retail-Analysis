create database retail_aanalysis_project
use retail_aanalysis_project

select top 6 * from login --(L) ------L.user_id = SO.fk_buyer_id								---------------6,66,375 rows
select top 6 * from sales_orders   --(SO) -----SO.order_id = SI.fk_order_id				---------------13,630 rows
select top 6 * from sales_items     --(SI)  ------ SO.order_id = SI.fk_order_id ---------------20,488 rows

1. Make a dataset (Using SQL) named �daily_logins� which contains the number of logins on a daily basis

----also see daily trend of login
select distinct date,count(log_id) over (partition by date order by date) as daily_logins from 
(select distinct login_log_id as log_id, convert(date,login_time) as date from login) as Sp order by date

2.daily trend of login and trend of conversion (no. order placed per login)

---no. of order placed per logins
select distinct convert(date,login_time)as date, login_log_id,COUNT(order_id) ORD_COUNT
from 
	(
	select *
	from login L FULL JOIN sales_orders SO
	ON L.user_id=SO.fk_buyer_id
	WHERE L.user_id=SO.fk_buyer_id

	) as Sp
GROUP BY login_log_id,convert(date,login_time)
order by login_log_id

--3. Prepare a report regarding our growth between the 2 years. Please try to answer the
--following questions:

	--a. Did our business grow?

---------year wise
select year(creation_time) year,count(distinct order_id) order_count,
sum(order_quantity_accepted*rate) total_revenue

from sales_items join sales_orders
on order_id=fk_order_id

where sales_order_status like 'shipped'
group by year(creation_time)



	--b. Does our app perform better now?


--------YEAR WISE


with cte1 as
(
		select year(creation_time) as order_year,count(order_id) shipped_order_count
		from sales_orders
		where sales_order_status like 'shipped'
		group by year(creation_time)

), 
cte2 as
(
select year(creation_time) as order_year,count(order_id) rejected_order_count
		from sales_orders
		where sales_order_status like 'rejected'
		group by year(creation_time)

),
cte3 as 
(
select year(login_time) login_year ,count(login_log_id) login_count,count(distinct user_id) user_id
from login 
group by year(login_time)

)

select cte1.order_year,shipped_order_count,rejected_order_count,login_count ,user_id
from cte1 join cte2 on cte1.order_year=cte2.order_year
join cte3 on cte3.login_year=cte2.order_year

	--c. Did our user base grow?
--------YEAR WISE

select year(login_time) year,count(distinct USER_ID) user_count from login group by year(login_time) order by year 

--4. What are our top-selling products in each of the two years? Can you draw some insight
--from this?

select year, fk_product_id, acc_orders_qty from 
(
	select year(creation_time) as year,  fk_product_id,
	sum(order_quantity_accepted)   as acc_orders_qty,
	 DENSE_RANK() over (partition by year(creation_time) order by sum(order_quantity_accepted) 
	 desc) as rank
	from sales_items  join sales_orders  on
	fk_order_id= order_id  
	where order_quantity_accepted>0
	group by year(creation_time), fk_product_id
) as sp
where rank = 1


--5. Looking at July 2021 data, what do you think is our biggest problem and how would you
--recommend fixing it?

select top 6 * from login 					
select top 6 * from sales_orders
select top 6 * from sales_items 

	show --- sum sales_ord_status / decline + login_count

	
with cte1 as
(
		select year(creation_time) as order_year,count(order_id) shipped_order_count
		from sales_orders
		where sales_order_status like 'shipped' and year(creation_time)='2021'
		group by year(creation_time)

), 
cte2 as
(
select year(creation_time) as order_year,count(order_id) rejected_order_count
		from sales_orders
		where sales_order_status like 'rejected' and year(creation_time)='2021'
		group by year(creation_time)

),
cte3 as 
(
select year(login_time) login_year ,count(login_log_id) login_count
from login 
where  year(login_time)='2021'
group by year(login_time)

)

select cte1.order_year,shipped_order_count,rejected_order_count,login_count 
from cte1 join cte2 on cte1.order_year=cte2.order_year
join cte3 on cte3.login_year=cte2.order_year



