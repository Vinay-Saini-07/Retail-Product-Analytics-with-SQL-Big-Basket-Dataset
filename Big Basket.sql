CREATE TABLE info(
                     Index int primary key,
                     Product VarChar(150),
                     Category VarChar(100),
                     Sub_Category VarChar(100),
                     Brand VarChar(50),
                     Sale_Price Numeric(10,2),
                     Market_Price Numeric(10,2),
                     Type VarChar(70),
                     Rating Numeric(3,1)

);


SELECT * FROM info;


--Data loaded
COPY 
      info(Index,Product,Category,Sub_Category,Brand,Sale_Price,Market_Price,Type,Rating)
      FROM 'D:\CSV Files\New BigBasket Products.csv'
CSV HEADER;


--1.Find the top 10 most expensive products by sale price.
SELECT index,product,Sale_price 
FROM info
ORDER BY Sale_price DESC 
LIMIT 10;


--2. List the top 5 brands with the highest number of products.
SELECT brand, COUNT(product) AS Number_of_Product
FROM info 
GROUP BY brand
ORDER BY Number_of_Product DESC 
LIMIT 5;


--3. Identify products where the sale price is equal to the market price (no discount).
SELECT index, product ,sale_price,market_price
FROM info
WHERE sale_price=market_price;


--4. Calculate the average discount Percentage of each category.
SELECT category,Sale_price,Market_Price,Round(AVG(Sale_price),2) AS Average_price,
Round(AVG((market_price-sale_price)/market_price*100),2) ||'%' AS Average_Discount_Percentage
FROM info 
GROUP BY category,market_price,Sale_price;


--5.Find the  Products with highest discount %
SELECT index,product,Market_price,Sale_price,
Round(((market_price-sale_price)/market_price*100),2) AS Discount_Percentage
FROM info
ORDER BY Discount_Percentage DESC
LIMIT 1;


--6. Find the sub_category with the highest average rating.
SELECT sub_category,round(AVG(rating),2) AS Average_Rating
From info
Group by sub_category
Order by Average_Rating DESC
Limit 1;


--7. Find the top 10 highest-rated products (rating ≥ 4.5).
SELECT distinct(Product),rating
FROM info 
WHERE rating>=4.5
ORDER Rating DESC
LIMIT 10;


--8. Calculate the total potential revenue if all products are sold at their sale price.
SELECT SUM(Sale_price) AS Total_Revenu
FROM info;


--9. Identify categories with the highest total profit margin (SUM(market_price – sale_price)).
SELECT category, SUM(market_price-Sale_price) AS Profit_margin
FROM info
GROUP BY category
ORDER BY Profit_margin DESC
LIMIT 1;


--10. Find duplicate product entries.
SELECT product, brand, category, COUNT(*) AS duplicate_count
FROM info
GROUP BY product, brand, category
HAVING COUNT(*) > 1;


--11. Find Top 5 categories with most products.
SELECT category, COUNT(*) AS total_products
FROM info
GROUP BY category
ORDER BY total_products DESC
LIMIT 5;


--12. List subcategories under each category.
SELECT DISTINCT category, sub_category
FROM info
ORDER BY category, sub_category;


--13. Minimum, maximum, and average price.
SELECT 
    MIN(Sale_price) AS min_price,
    MAX(Sale_price) AS max_price,
    ROUND(AVG(Sale_price),2) AS avg_price
FROM info;


--14. Get the average rating per category and rank them from highest to lowest.
Select * ,
 Dense_Rank() Over(Order by Average_Rating Desc) As Ranking 
from(
     --Subquery to Calculate the Average Rating Per Category
Select Category, Round(Avg(rating),2) As Average_Rating
From info
Group by Category
) As Average_Rating;


--15. Price distribution buckets
SELECT 
    CASE 
        WHEN Sale_price BETWEEN 0 AND 100 THEN '0-100'
        WHEN Sale_price BETWEEN 101 AND 500 THEN '101-500'
        WHEN Sale_price BETWEEN 501 AND 1000 THEN '501-1000'
        ELSE '1000+'
    END AS price_range,
    COUNT(*) AS Number_Of_Product
FROM info
GROUP BY price_range
ORDER BY Number_Of_Product DESC;





