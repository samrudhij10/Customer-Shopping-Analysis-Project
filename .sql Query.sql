--	Fetch All Data From Table
select * from customer 

--Q1 what is total revenue generate by male vs female customer ?
select gender , Sum(purchase_amount) as revenue
from customer
group by gender 

--Q2 Which customer used a discount but still spent more than average purchase amount
select customer_id,purchase_amount
where discount_applied =='Yes' and purchase_amount 

--	Fetch All Data From Table
select * from customer 

--Q1 what is total revenue generate by male vs female customer ?
select gender , Sum(purchase_amount) as revenue
from customer
group by gender 

--Q2 Which customer used a discount but still spent more than average purchase amount?
select customer_id , purchase_amount
from customer
where discount_applied = 'Yes' and 
purchase_amount >= (select avg(purchase_amount)from customer)

--Q3 which are top 5 product with highest average rating ?
select item_purchased, avg (review_rating)
as "highes_avg_rating" 
from customer 
group by item_purchased
order by  avg (review_rating) desc
limit 5

--Q4 compare average purchase_amount with the standard and express shipping 
select shipping_type , avg (purchase_amount)
from customer 
where shipping_type in ('Standard','Express')
group by shipping_type

--Q5 Do subscribed customer spend more ? compare average spend and total revenue between subscriber and no-subscriber ?
select subscription_status , 
count(customer_id) as total_customer ,
avg (purchase_amount) as average_spend,
sum (purchase_amount) as totol_revenue
from customer 
group by subscription_status
order by totol_revenue,average_spend desc ;

-- Q6 which 5 product have highest percentage of purchases with discount applied ?
select item_purchased,
round (100.0* sum (case when discount_applied='yes' then 1 else 0 end)/ count(*),2)as discount_rate
from customer
group by item_purchased
order by discount_rate desc
limit 5 ;

--Q7 Segemnt customer into new, returning based on theie total number of previous purchase and show the count of each segment ?
with customer_type as (
 select customer_id,previous_purchases,
 case
      when previous_purchases =1 then 'NEW'
	  when previous_purchases BETWEEN 2 AND 10 then 'returning'
	  ELSE 'ROYAL'
	  END AS customer_segment
from customer
)
select customer_segment, count(*) as "Number_of_Customer"
from customer_type
group by customer_segment

--Q8 What are top 3 most purchase products within each category ?
WITH item_counts AS (
    SELECT 
        category,
        item_purchased,
        COUNT(customer_id) AS total_orders,
        
        ROW_NUMBER() OVER (
            PARTITION BY category 
            ORDER BY COUNT(customer_id) DESC
        ) AS item_rank
        
    FROM customer
    GROUP BY category, item_purchased
)

SELECT 
    item_rank,
    category,
    item_purchased,
    total_orders

FROM item_counts

WHERE item_rank <= 3;

--Q9  Are customer who are repeat buyers  (more than 5 year purchase) also likely to subscribe?
select subscription_status,
count(customer_id)as repeat_buyers
from customer
where previous_purchases > 5 
group by subscription_status

--Q10 What is revenue constribution of each age gruop
select age_group,
sum(purchase_amount) as total_revenue
from customer
group by age_group
order by (total_revenue)desc;