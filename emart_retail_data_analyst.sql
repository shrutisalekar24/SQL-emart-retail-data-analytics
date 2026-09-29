USE ELECTROMART;

/*-- "Project Summary:
This project focuses on analyzing retail data of ElectroMart using MySQL.
It includes customer details, product information, and sales records.
I used SQL queries to analyze customer locations, product pricing, order trends,
payment modes, brand performance, unsold products, and customer spending.
I practiced filtering, aggregation, GROUP BY, HAVING, JOINs, subqueries, and
window functions to generate useful business insights."
*/

use electromartdb;
alter table customers
modify column customer_Name varchar(50),
modify column gender varchar(50),
modify column age_group varchar(50),
modify column date_of_birth varchar(50),
modify column Email varchar(50),
modify column Phone varchar(50),
modify column State varchar(50),
modify column Registration_Date varchar(50),
modify column Customer_Tier varchar(50),
modify column Total_spent varchar(50);

alter table products
modify column product_name varchar(50),
modify column category varchar(50),
modify column brand varchar(50);

alter table sales
modify column  order_date varchar(50),
modify column  order_time varchar(50),
modify column  delivery_date varchar(50),
modify column  coupon_code varchar(50),
modify column  payment_mode varchar(50),
modify column  order_status varchar(50),
modify column  rating varchar(50),
modify column  review_text varchar(50);





alter table sales
modify customer_id varchar(50);

alter table sales
modify product_id varchar(50);


alter table sales
add constraint fk_customer
foreign key (customer_id) references customers(customer_id);

ALTER TABLE Sales
ADD CONSTRAINt FOREIGN_KEY_product_id 
FOREIGN KEY (Product_ID) REFERENCES Products(Product_ID);
describe sales;
SHOW CREATE TABLE Sales;

#KPI

#Q1 Total Revenue
SELECT round(SUM(Total_Amount),0) AS TotalRevenue
FROM Sales;


#Q2 Total Orders
SELECT COUNT(Order_ID) AS TotalOrders
FROM Sales;

#Q3 Average Order Value
SELECT ROUND(AVG(Total_Amount),0) AS AvgOrderValue
FROM Sales;

#Q4 Total Customers
SELECT COUNT(Customer_ID) AS TotalCustomers
FROM Sales;


# OTHER INSIGHTS
#Q1  Customers from Maharashtra (WHERE)
SELECT *
FROM CUSTOMERS 
WHERE STATE = 'Maharashtra';

#Q2 Products priced above ₹50,000 (Comparison operator)
SELECT *
FROM PRODUCTS
WHERE SELLING_PRICE > 50000;

#Q3 Customers whose names start with ‘R’ (String function)
SELECT * 
FROM CUSTOMERS 
WHERE CUSTOMER_NAME LIKE 'R%';


#Q4 Orders placed between Jan–Jun 2026 (Date/Time function)
SELECT *
FROM SALES 
WHERE ORDER_DATE BETWEEN '2026-01-01' AND '2026-06-30';

#Q5 Orders with customer city and product brand (JOIN)
SELECT S.ORDER_ID,C.CUSTOMER_NAME, C.CITY, P.BRAND
FROM SALES S
JOIN CUSTOMERS C 
ON S.CUSTOMER_ID = C.CUSTOMER_ID
JOIN PRODUCTS P 
ON S.PRODUCT_ID = P.PRODUCT_ID;
 
 
#Q6 Orders per payment mode (GROUP BY)
SELECT PAYMENT_MODE, COUNT(*) AS ORDERSCOUNT
FROM SALES
GROUP BY PAYMENT_MODE;



#Q7 Brands with average price > ₹40,000
SELECT BRAND, AVG(SELLING_PRICE) AS AVGPRICE
FROM PRODUCTS
GROUP BY BRAND
HAVING AVGPRICE > 40000;

#Q8 Top Brand by Sales
SELECT Brand, ROUND(SUM(Total_Amount)) AS BrandRevenue
FROM Products p
JOIN Sales s ON p.Product_ID = s.Product_ID
GROUP BY Brand
ORDER BY BrandRevenue DESC
LIMIT 1;



#Q9 Distinct brands available (DISTINCT)
SELECT DISTINCT BRAND 
FROM PRODUCTS;

#Q10 Orders sorted by highest value (ORDER BY)
SELECT ORDER_ID, TOTAL_AMOUNT
FROM SALES
ORDER BY TOTAL_AMOUNT DESC;


-- 🟣 Subqueries
#Q11 Products never ordered 
SELECT PRODUCT_NAME
FROM PRODUCTS
WHERE PRODUCT_ID NOT IN (
SELECT DISTINCT PRODUCT_ID 
FROM SALES);


#Q12 Customers who placed orders above average order value 
SELECT CUSTOMER_ID, TOTAL_AMOUNT
FROM SALES
WHERE TOTAL_AMOUNT > (SELECT AVG(TOTAL_AMOUNT) FROM SALES);


-- 🔴 Window Functions (2 Compulsory)
#Q13 Rank customers by spending (RANK)
SELECT CUSTOMER_ID, ORDER_ID, TOTAL_AMOUNT,
       RANK() OVER (PARTITION BY CUSTOMER_ID ORDER BY TOTAL_AMOUNT DESC) AS ORDER_RANK
FROM SALES;


#Q14 Rank brand by selling price (DENSE_RANK)
SELECT BRAND,  SELLING_PRICE,
       DENSE_RANK() OVER (PARTITION BY BRAND ORDER BY SELLING_PRICE DESC) AS RANKWITHINBRAND
FROM PRODUCTS;
