-- Codebasics SQL Challenge
-- DB name - gdb023

# 1. Provide the list of markets in which customer "Atliq Exclusive" operates its business in the APAC region.
	SELECT
		distinct(market)
    FROM dim_customer
    WHERE customer = "Atliq Exclusive" and region = "APAC";
 -- ---------------------------------------------------------------------------------------------------------------------------------------
 
#2. What is the percentage of unique product increase in 2021 vs. 2020?
#	The final output contains these fields, 
		-- unique_products_2020 
        -- unique_products_2021 
        -- percentage_chg
	WITH products_2020 AS (
					SELECT count(distinct product_code) as unique_product_2020
					FROM fact_sales_monthly
					WHERE fiscal_year = 2020
				 ),
		products_2021 AS (
					SELECT count(distinct product_code) as unique_product_2021
					FROM fact_sales_monthly
					WHERE fiscal_year = 2021
				)
	SELECT 
		*,
		ROUND(abs(unique_product_2020 - unique_product_2021)/unique_product_2020 * 100,2) as percentage_chg
	FROM products_2020,products_2021;
 -- ---------------------------------------------------------------------------------------------------------------------------------------
 
 # 3. Provide a report with all the unique product counts for each segment and sort them in descending order of product counts. 
 --   The final output contains 2 fields, 
 --   segment 
 --   product_count
SELECT
	segment,
	count(product) as product_count
FROM dim_product
GROUP BY segment
ORDER BY product_count DESC;


#4.Follow-up: Which segment had the most increase in unique products in 2021 vs 2020? 
-- The final output contains these fields, 1.segment 2.product_count_2020 3.product_count_2021 4.difference
-- PARTIALLY SOLVED
WITH product_2020 AS(
						SELECT
							count(DISTINCT product) AS product_count_2020
						FROM dim_product p
                        JOIN fact_sales_monthly s
							ON p.product_code = s.product_code
						WHERE fiscal_year = 2020
						ORDER BY product_count_2020 DESC),
		product_2021 AS  (
						SELECT
							count(DISTINCT product) AS product_count_2021
						FROM dim_product p
                        JOIN fact_sales_monthly s
							ON p.product_code = s.product_code
						WHERE fiscal_year = 2021
						ORDER BY product_count_2021 DESC
					)
SELECT segment, product_count_2020, product_count_2020 FROM product_2020, product_2021, dim_product 
GROUP BY segment;

# 5. Get the products that have the highest and lowest manufacturing costs. 
-- The final output should contain these fields, 1. product_code 2. product 3. manufacturing_cost
-- PARTIALLY SOLVED
    SELECT 
		m.product_code,
		p.product,
        -- m.manufacturing_cost
		MAX(m.manufacturing_cost) as max_cost
    FROM fact_manufacturing_cost m
    JOIN dim_product p
    ON m.product_code = p.product_code
    WHERE cost_year = 2020;
    
# 6. Generate a report which contains the top 5 customers who received an average high pre_invoice_discount_pct for the fiscal year 2021 
-- 	and in the Indian market. The final output contains these fields, customer_code customer average_discount_percentage
SELECT 
	pre.customer_code,
    c.customer,
    ROUND(pre.pre_invoice_discount_pct*100,2) as average_discount_percentage
FROM fact_pre_invoice_deductions pre
JOIN dim_customer c
	ON pre.customer_code = c.customer_code
WHERE fiscal_year = 2021 AND market = "India"
ORDER BY pre_invoice_discount_pct DESC
LIMIT 5;

# 7. Get the complete report of the Gross sales amount for the customer “Atliq Exclusive” for each month . 
-- This analysis helps to get an idea of low and high-performing months and take strategic decisions. 
-- The final report contains these columns: Month Year Gross sales Amount

SELECT
    MONTH(s.date),
    YEAR(s.date),
    ROUND(SUM(s.sold_quantity*g.gross_price)/1000000,2) as gross_sales_amount_in_mln
FROM dim_customer c
JOIN fact_sales_monthly s
	ON c.customer_code = s.customer_code
JOIN fact_gross_price g
	ON s.product_code = g.product_code
WHERE customer = "Atliq Exclusive"
GROUP BY MONTH(s.date)
ORDER BY gross_sales_amount_in_mln DESC
    
    
    