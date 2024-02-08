select *
From AddidasSales
order by 3


----SALES PERFORMANCE ANALYSIS For Addidas (What is the trend in total sales over time?) THIS COMMAND GIVES US THE MONTH, DAY AND YEAR WHERE ADDIDAS REALIZED THE MOST SALE
SELECT MONTH(InvoiceDate) AS month, SUM(TotalSales) AS total_sales
FROM AddidasSales
GROUP BY MONTH(InvoiceDate)
ORDER BY MONTH(InvoiceDate) DESC;


SELECT DAY(InvoiceDate) AS day, SUM(TotalSales) AS total_sales
FROM AddidasSales
GROUP BY DAY(InvoiceDate)
ORDER BY DAY(InvoiceDate) DESC;


SELECT YEAR(InvoiceDate) AS year, SUM(TotalSales) AS total_sales
FROM AddidasSales
GROUP BY YEAR(InvoiceDate)
ORDER BY YEAR(InvoiceDate) DESC;


----Sales by Product Category
SELECT Product, SUM(TotalSales) AS CategorySales
FROM AddidasSales
GROUP BY Product
ORDER BY SUM(TotalSales) DESC;


----Sales by Region, State, Sales method and Retailer
SELECT State, SUM(TotalSales) AS CategorySales
FROM AddidasSales
GROUP BY State
ORDER BY SUM(TotalSales) DESC;

SELECT Region, SUM(TotalSales) AS CategorySales
FROM AddidasSales
GROUP BY Region
ORDER BY SUM(TotalSales) DESC;

SELECT SalesMethod, SUM(TotalSales) AS CategorySales
FROM AddidasSales
GROUP BY SalesMethod
ORDER BY SUM(TotalSales) DESC;

SELECT Retailer, SUM(TotalSales) AS CategorySales
FROM AddidasSales
GROUP BY Retailer
ORDER BY SUM(TotalSales) DESC;


----PROFITABILITY ANALYSIS FOR ADDIDAS SALES
SELECT Product, 
    CASE 
        WHEN TotalSales = 0 THEN 0 -- If TotalSales is zero, set ProfitMargin to 0
        ELSE (CONVERT(FLOAT, OperatingProfit) / CONVERT(FLOAT, NULLIF(TotalSales, 0))) * 100 
    END AS ProfitMargin
FROM AddidasSales
ORDER BY ProfitMargin DESC;


----I need to update the ProfitMargin into the Addidas sales table for further useful calculations
ALTER TABLE AddidasSales
Add ProfitMargin FLOAT;

UPDATE AddidasSales
SET ProfitMargin = 
    CASE 
        WHEN TotalSales = 0 THEN 0 
        ELSE (CONVERT(FLOAT, OperatingProfit) / CONVERT(FLOAT, NULLIF(TotalSales, 0))) * 100 
    END;


---Profitability by region and sales method
SELECT Region, SalesMethod, SUM(ProfitMargin) as TotalProfitMarginbyRegionAndSalesMethod
FROM AddidasSales
GROUP BY SalesMethod, Region
ORDER BY SUM(ProfitMargin) DESC;


----Moving Average--to understand the general trend of sales and smooth out fluctuation by retailer and invoice date
SELECT Retailer, InvoiceDate, TotalSales, AVG(TotalSales) OVER (PARTITION BY Retailer, InvoiceDate ORDER BY InvoiceDate ROWS BETWEEN 1 PRECEDING AND CURRENT ROW) AS MovingAverage
FROM AddidasSales;


----I need to make the moving average a table of its own
SELECT Retailer, InvoiceDate, TotalSales, AVG(TotalSales) OVER (PARTITION BY Retailer, InvoiceDate ORDER BY InvoiceDate ROWS BETWEEN 1 PRECEDING AND CURRENT ROW) AS MovingAverage
INTO AddidasSalesMovingAvg
FROM AddidasSales;

select *
From AddidasSalesMovingAvg

