USE ecomm;
SET SQL_SAFE_UPDATES = 0;

UPDATE customer_churn SET WarehouseToHome = 16 WHERE WarehouseToHome IS NULL;
UPDATE customer_churn SET HourSpendOnApp = 3 WHERE HourSpendOnApp IS NULL;
UPDATE customer_churn SET OrderAmountHikeFromLastYear = 16 WHERE OrderAmountHikeFromLastYear IS NULL;
UPDATE customer_churn SET DaySinceLastOrder = 5 WHERE DaySinceLastOrder IS NULL;
-- 1. Find Mode for Tenure
SELECT Tenure, COUNT(*) AS frequency 
FROM customer_churn 
WHERE Tenure IS NOT NULL 
GROUP BY Tenure 
ORDER BY frequency DESC 
LIMIT 1;

-- 2. Find Mode for CouponUsed
SELECT CouponUsed, COUNT(*) AS frequency 
FROM customer_churn 
WHERE CouponUsed IS NOT NULL 
GROUP BY CouponUsed 
ORDER BY frequency DESC 
LIMIT 1;

-- 3. Find Mode for OrderCount
SELECT OrderCount, COUNT(*) AS frequency 
FROM customer_churn 
WHERE OrderCount IS NOT NULL 
GROUP BY OrderCount 
ORDER BY frequency DESC 
LIMIT 1;
UPDATE customer_churn SET Tenure = 1 WHERE Tenure IS NULL;
UPDATE customer_churn SET CouponUsed = 1 WHERE CouponUsed IS NULL;
UPDATE customer_churn SET OrderCount = 2 WHERE OrderCount IS NULL;
DELETE FROM customer_churn 
WHERE WarehouseToHome > 100;
-- 1. Replace "Phone" with "Mobile Phone" in PreferredLoginDevice
UPDATE customer_churn
SET PreferredLoginDevice = 'Mobile Phone'
WHERE PreferredLoginDevice = 'Phone';

-- 2. Replace "Mobile" with "Mobile Phone" in PreferedOrderCat
UPDATE customer_churn
SET PreferedOrderCat = 'Mobile Phone'
WHERE PreferedOrderCat = 'Mobile';
-- 1. Replace "COD" with "Cash on Delivery"
UPDATE customer_churn
SET PreferredPaymentMode = 'Cash on Delivery'
WHERE PreferredPaymentMode = 'COD';

-- 2. Replace "CC" with "Credit Card"
UPDATE customer_churn
SET PreferredPaymentMode = 'Credit Card'
WHERE PreferredPaymentMode = 'CC';
ALTER TABLE customer_churn 
CHANGE COLUMN PreferedOrderCat PreferredOrderCat VARCHAR(50);

ALTER TABLE customer_churn 
CHANGE COLUMN HourSpendOnApp HoursSpentOnApp INT;

ALTER TABLE customer_churn 
ADD COLUMN ComplaintReceived VARCHAR(10),
ADD COLUMN ChurnStatus VARCHAR(10);

UPDATE customer_churn
SET ComplaintReceived = CASE WHEN Complain = 1 THEN 'Yes' ELSE 'No' END,
    ChurnStatus = CASE WHEN Churn = 1 THEN 'Churned' ELSE 'Active' END;

ALTER TABLE customer_churn 
DROP COLUMN Churn,
DROP COLUMN Complain;

SELECT 
    ROUND(AVG(Tenure), 2) AS AverageTenure,
    SUM(CashbackAmount) AS TotalCashback
FROM customer_churn
WHERE ChurnStatus = 'Churned';
SELECT 
    ROUND(
        (COUNT(CASE WHEN ComplaintReceived = 'Yes' THEN 1 END) * 100.0) / COUNT(*), 
        2
    ) AS ChurnedComplaintPercentage
FROM customer_churn
WHERE ChurnStatus = 'Churned';
SELECT 
    CityTier, 
    COUNT(*) AS ChurnedCustomerCount
FROM customer_churn
WHERE ChurnStatus = 'Churned' 
  AND PreferredOrderCat = 'Laptop & Accessory'
GROUP BY CityTier
ORDER BY ChurnedCustomerCount DESC
LIMIT 1;
SELECT 
    SUM(OrderAmountHikeFromLastYear) AS TotalOrderAmountHike
FROM customer_churn
WHERE MaritalStatus = 'Single' 
  AND PreferredLoginDevice = 'Mobile Phone';
  SELECT 
    ROUND(AVG(OrderCount), 2) AS AverageOrderCount
FROM customer_churn
WHERE MaritalStatus = 'Married' 
  AND CouponUsed > 0;
  SELECT 
    ChurnStatus, 
    ROUND(AVG(SatisfactionScore), 2) AS AverageSatisfactionScore
FROM customer_churn
GROUP BY ChurnStatus;
SELECT 
    MAX(HoursSpentOnApp) AS MaxHoursSpent
FROM customer_churn
WHERE ChurnStatus = 'Churned';
SELECT 
    COUNT(*) AS HighRiskChurnedCustomers
FROM customer_churn
WHERE WarehouseToHome > 15 
  AND ComplaintReceived = 'Yes' 
  AND ChurnStatus = 'Churned';
  SELECT 
    MaritalStatus, 
    PreferredOrderCat, 
    COUNT(*) AS TotalCustomers
FROM customer_churn
GROUP BY MaritalStatus, PreferredOrderCat
ORDER BY MaritalStatus, TotalCustomers DESC;
SELECT 
    ROUND(AVG(NumberOfDeviceRegistered), 2) AS AvgDevicesRegistered
FROM customer_churn
WHERE PreferredPaymentMode = 'UPI';
SELECT 
    CityTier, 
    COUNT(*) AS TotalCustomers
FROM customer_churn
GROUP BY CityTier
ORDER BY TotalCustomers DESC
LIMIT 1;
SELECT 
    Gender, 
    SUM(CouponUsed) AS TotalCouponsUsed
FROM customer_churn
GROUP BY Gender
ORDER BY TotalCouponsUsed DESC
LIMIT 1;
SELECT 
    PreferredOrderCat, 
    COUNT(*) AS CustomerCount, 
    MAX(HoursSpentOnApp) AS MaxHoursSpent
FROM customer_churn
GROUP BY PreferredOrderCat;
SELECT 
    SUM(OrderCount) AS TotalOrderCount
FROM customer_churn
WHERE PreferredPaymentMode = 'Credit Card' 
  AND SatisfactionScore = (SELECT MAX(SatisfactionScore) FROM customer_churn);
  SELECT 
    ROUND(AVG(SatisfactionScore), 2) AS AvgSatisfactionScore
FROM customer_churn
WHERE ComplaintReceived = 'Yes';
SELECT 
    PreferredOrderCat, 
    COUNT(*) AS CustomerCount
FROM customer_churn
WHERE CouponUsed > 5
GROUP BY PreferredOrderCat
ORDER BY CustomerCount DESC;
SELECT 
    PreferredOrderCat, 
    ROUND(AVG(CashbackAmount), 2) AS AvgCashback
FROM customer_churn
GROUP BY PreferredOrderCat
ORDER BY AvgCashback DESC
LIMIT 3;
SELECT DISTINCT 
    PreferredPaymentMode 
FROM customer_churn
WHERE Tenure = 10 
  AND OrderCount > 500;
  SELECT 
    CASE 
        WHEN WarehouseToHome <= 5 THEN 'Very Close Distance'
        WHEN WarehouseToHome <= 10 THEN 'Close Distance'
        WHEN WarehouseToHome <= 15 THEN 'Moderate Distance'
        ELSE 'Far Distance'
    END AS DistanceCategory,
    ChurnStatus,
    COUNT(*) AS CustomerCount
FROM customer_churn
GROUP BY DistanceCategory, ChurnStatus
ORDER BY DistanceCategory, ChurnStatus;
SELECT *
FROM customer_churn
WHERE MaritalStatus = 'Married'
  AND CityTier = 1
  AND OrderCount > (SELECT AVG(OrderCount) FROM customer_churn);
  -- Step 1: Create table
CREATE TABLE customer_returns (
    ReturnID INT PRIMARY KEY,
    CustomerID INT,
    ReturnDate DATE,
    RefundAmount INT
);


INSERT INTO customer_returns (ReturnID, CustomerID, ReturnDate, RefundAmount) VALUES
(1001, 50022, '2023-01-01', 2130),
(1002, 50316, '2023-01-23', 2000),
(1003, 51099, '2023-02-14', 2290),
(1004, 52321, '2023-03-08', 2510),
(1005, 52928, '2023-03-20', 3000),
(1006, 53749, '2023-04-17', 1740),
(1007, 54206, '2023-04-21', 3250),
(1008, 54838, '2023-04-30', 1990);
SELECT 
    r.ReturnID,
    r.CustomerID,
    r.ReturnDate,
    r.RefundAmount,
    c.*
FROM customer_returns r
INNER JOIN customer_churn c 
    ON r.CustomerID = c.CustomerID
WHERE c.ChurnStatus = 'Churned' 
  AND c.ComplaintReceived = 'Yes';
  SELECT * 
FROM customer_churn;