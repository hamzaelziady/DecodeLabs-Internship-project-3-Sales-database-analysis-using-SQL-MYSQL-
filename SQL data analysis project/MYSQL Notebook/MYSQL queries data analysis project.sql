Create database Sales_db
USE Sales_db;
CREATE TABLE orders (
    OrderID VARCHAR(255) PRIMARY KEY,
    OrderDate DATE,
    CustomerID VARCHAR(255),
    Product VARCHAR(255),
    Quantity INT,
    UnitPrice DECIMAL(10,2),
    ShippingAddress VARCHAR(255),
    PaymentMethod VARCHAR(50),
    OrderStatus VARCHAR(50),
    TrackingNumber VARCHAR(100),
    ItemsInCart INT,
    CouponCode VARCHAR(50),
    ReferralSource VARCHAR(50),
    TotalPrice DECIMAL(10,2)
);
-- replace null--
SELECT * FROM sales_db.orders;
UPDATE sales_db.orders
SET CouponCode = 'No Coupon'
WHERE CouponCode = '';
-- count duplicates--
SELECT `OrderID`,
       COUNT(*) AS Duplicate_Count
FROM sales_db.orders
GROUP BY `OrderID`
HAVING COUNT(*) > 1;
-- check is there are negative or zero prices--
SELECT *
FROM sales_db.orders
WHERE TotalPrice <= 0;
-- count customers --
SELECT COUNT(DISTINCT `CustomerID`) AS Total_Customers
FROM sales_db.orders;
-- count total orders --
SELECT COUNT(*) AS Total_Orders
FROM sales_db.orders;
-- orders by month--
SELECT 
    YEAR(OrderDate) AS Year,
    COUNT(*) AS Orders_Per_year
FROM sales_db.orders
GROUP BY YEAR(OrderDate);
-- highest order--
SELECT *
FROM sales_db.orders
ORDER BY TotalPrice DESC
LIMIT 1;
-- lowest orders--
SELECT *
FROM sales_db.orders
ORDER BY TotalPrice ASC
LIMIT 1;
-- orders status--
SELECT OrderStatus,
       COUNT(*) AS status_count
FROM sales_db.orders
GROUP BY OrderStatus
ORDER BY status_count DESC;
-- total revenue for succesful sales--
SELECT SUM(TotalPrice) AS Total_Revenue
FROM sales_db.orders
WHERE OrderStatus = 'Delivered';
-- average revenue per succesful order--
SELECT AVG(TotalPrice) AS Average_Order_Value
FROM sales_db.orders
WHERE OrderStatus = 'Delivered';
-- revenue by month--
SELECT 
    YEAR(OrderDate) AS Year,
    sum(TotalPrice) AS Revenue_per_year
FROM sales_db.orders
GROUP BY YEAR(OrderDate);
-- revenue by payment method--
SELECT PaymentMethod,
       SUM(TotalPrice) AS Revenue_by_payment_method
FROM sales_db.orders
WHERE OrderStatus = 'Delivered'
GROUP BY PaymentMethod
ORDER BY Revenue_by_payment_method DESC;
-- revenue by Referral source--
SELECT ReferralSource,
       SUM(TotalPrice) AS Revenue_by_Refferal
FROM sales_db.orders
WHERE OrderStatus = 'Delivered'
GROUP BY ReferralSource
ORDER BY Revenue_by_Refferal DESC;
-- revenue by coupon users for delivered only--
SELECT SUM(TotalPrice) AS Coupon_Revenue
FROM sales_db.orders
WHERE CouponCode != 'No Coupon' and OrderStatus = 'Delivered';
-- revenue by non coupon users for delivered only--
SELECT SUM(TotalPrice) AS Non_Coupon_Revenue
FROM sales_db.orders
WHERE CouponCode = 'No Coupon' and OrderStatus = 'Delivered';
-- number of delivered products--
SELECT Product,
       SUM(Quantity) AS Total_Units_Sold
FROM sales_db.orders
WHERE OrderStatus = 'Delivered'
GROUP BY Product
ORDER BY Total_Units_Sold DESC;
-- revenue by each delivered  product--
SELECT Product,
       SUM(TotalPrice) AS Revenue_by_product
FROM sales_db.orders
WHERE OrderStatus = 'Delivered'
GROUP BY Product
ORDER BY Revenue_by_product DESC;
-- most expensive products--
select Product,
	max(UnitPrice) as MAX_unit_price
from sales_db.orders
group by product
order by MAX_unit_price desc;
-- top 10 customers by spending--
SELECT CustomerID,
       SUM(TotalPrice) AS Total_Spent
FROM sales_db.orders
where OrderStatus = 'Delivered'
GROUP BY CustomerID
ORDER BY Total_Spent DESC
limit 10;
-- most frequent payment method--
SELECT PaymentMethod,
       COUNT(*) AS method_Count
FROM sales_db.orders
GROUP BY PaymentMethod
ORDER BY method_Count DESC;
-- revenue per payment method for dilevered orders from highest--
SELECT PaymentMethod,
       sum(TotalPrice) AS revenue_method
FROM sales_db.orders
where OrderStatus = 'Delivered'
GROUP BY PaymentMethod
order by revenue_method desc;
-- avergae order value by payment method for dilevered orders--
SELECT PaymentMethod,
       round(avg(TotalPrice),2) AS avg_revenue_method
FROM sales_db.orders
where OrderStatus = 'Delivered'
GROUP BY PaymentMethod
order by avg_revenue_method desc;
-- most used coupon --
SELECT CouponCode,
       COUNT(*) AS coupon_Count
FROM sales_db.orders
GROUP BY CouponCode
ORDER BY coupon_Count DESC;
-- most used coupon for dilevered orders --
SELECT CouponCode,
       COUNT(*) AS coupon_Count_dilevered
FROM sales_db.orders
where OrderStatus = 'Delivered'
GROUP BY CouponCode
ORDER BY coupon_Count_dilevered DESC;
-- revenue by coupon type for dilevered --
SELECT CouponCode,
       sum(TotalPrice) AS revenue_coupon
FROM sales_db.orders
where OrderStatus = 'Delivered'
GROUP BY CouponCode
order by revenue_coupon desc;
-- average order value with coupon --
SELECT AVG(TotalPrice) AS Avg_Coupon_revenue
FROM sales_db.orders
WHERE CouponCode != 'No Coupon' and OrderStatus = 'Delivered';
-- average order value without coupon --
SELECT AVG(TotalPrice) AS Avg_NO_Coupon_revenue
FROM sales_db.orders
WHERE CouponCode = 'No Coupon' and OrderStatus = 'Delivered' ;
-- most effective referral source in general--
SELECT ReferralSource,
       COUNT(*) AS Orders_by_referrals
FROM sales_db.orders
GROUP BY ReferralSource
ORDER BY Orders_by_referrals DESC;
-- most effective referral source for delivered--
SELECT ReferralSource,
       COUNT(*) AS Orders_by_referrals
FROM sales_db.orders
where OrderStatus = 'Delivered'
GROUP BY ReferralSource
ORDER BY Orders_by_referrals DESC;
-- revenue by referal source for delivered--
SELECT ReferralSource,
       sum(TotalPrice) AS revenue_by_referrals
FROM sales_db.orders
where OrderStatus = 'Delivered'
GROUP BY ReferralSource
ORDER BY revenue_by_referrals DESC;
-- average revenue by referal source for delivered--
SELECT ReferralSource,
       round(avg(TotalPrice),2) AS revenue_by_referrals
FROM sales_db.orders
where OrderStatus = 'Delivered'
GROUP BY ReferralSource
ORDER BY revenue_by_referrals DESC;
-- delivery success rate--
SELECT 
    (COUNT(CASE WHEN OrderStatus = 'Delivered' THEN 1 END) * 100.0 / COUNT(*))
    AS Delivery_Rate
FROM sales_db.orders;
-- delivery return rate--
SELECT 
    (COUNT(CASE WHEN OrderStatus = 'Returned' THEN 1 END) * 100.0 / COUNT(*))
    AS return_Rate
FROM sales_db.orders;
-- delivery cancellation rate--
SELECT 
    (COUNT(CASE WHEN OrderStatus = 'Cancelled' THEN 1 END) * 100.0 / COUNT(*))
    AS cancel_Rate
FROM sales_db.orders;
-- products frequently bought by coupon--
SELECT Product,
       COUNT(*) AS Coupon_Orders
FROM sales_db.orders
WHERE CouponCode != 'No Coupon'
GROUP BY Product
ORDER BY Coupon_Orders DESC;
-- average cart size--
SELECT avg(`ItemsinCart`) AS Avg_Cart_Size
FROM sales_db.orders;






