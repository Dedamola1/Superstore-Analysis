USE SuperStoreData

-- Sales, Quantity, Discount and Profit for each product
SELECT Product_ID,Sales, Quantity, Discount, Profit
from Sales.Orders;

-- Different ship mode available
SELECT DISTINCT Ship_Mode
FROM Sales.Orders;

-- Unit price for each product
SELECT Product_ID,Sales, Quantity, [Unit Price] = Sales/Quantity
FROM Sales.orders;

-- New discount price for each product
SELECT Sales, Discount, [New Discount] = Sales*0.02
FROM Sales.Orders;

-- Total sales, discount and profit
 SELECT [Total Sales] = SUM(Sales),
		[Total Discount] = SUM(Discount),
		[Total Profit] = SUM(Profit)
 FROM Sales.orders;

 -- Total sales for each ship mode
 SELECT Ship_Mode,
		[Total Sales] = SUM(Sales)
 FROM Sales.Orders
GROUP BY Ship_Mode;

-- Total, Average, Highest and Lowest sales for each ship mode
SELECT Ship_Mode,
		SUM(sales) [Total Sales], 
		AVG(sales) [Average of Sales],
		MAX(sales) [Highest Sales],
		MIN(sales) [Lowest Sales],
		COUNT(Sales) [Count of Sales]
 FROM Sales.Orders
 GROUP BY Ship_Mode
 ORDER BY [Total Sales] DESC;

 -- Total Sales and No of sales made for 'Same Day' Ship Mode
 SELECT Ship_Mode,
		SUM(sales) [Total Sales], 
		COUNT(Sales) [Count of Sales]
 FROM Sales.Orders
 GROUP BY Ship_Mode
 HAVING Ship_Mode = 'Same Day';

 -- Total quantity of sales by sales rep
 SELECT Sales_Rep_ID,
		[Total Quantity of sales] = SUM(Quantity)
 FROM Sales.Orders
 GROUP BY Sales_Rep_ID
 ORDER BY[Total Quantity of sales] DESC;

 -- Total sales for each Location above 1000
 SELECT Location_ID,
		[Total Sales] = SUM(Sales)
 FROM Sales.Orders
 GROUP BY Location_ID
 HAVING SUM(Sales) > 1000;

 -- Total number of sales by sales rep except ID 22001
 SELECT Sales_Rep_ID, 
		[Total Sales] = SUM(Sales)
 FROM Sales.Orders
 GROUP BY Sales_Rep_ID
 HAVING Sales_Rep_ID != 22001
 ORDER BY [Total Sales] DESC;

 -- Total number of orders made in each year
 SELECT DATEPART(YEAR,Order_Date) as Year,
		[Total Orders] = COUNT(Order_Date)
 FROM Sales.Orders
 GROUP BY DATEPART(YEAR,Order_Date)
 ORDER BY Year;

 -- Shipment made within three days after order date
 SELECT Order_ID,
		Order_Date,
		Ship_Date,
		DATEDIFF(DAY, Order_Date, Ship_Date) as [Delivery Time(In Days)]
 FROM Sales.Orders
 WHERE DATEDIFF(DAY, Order_Date, Ship_Date) <= 3
 ORDER BY [Delivery Time(In Days)] DESC;

 -- Delivery Type using Case Statement
 SELECT Order_ID, 
		DATEDIFF(DAY, Order_Date, Ship_Date) as [Delivery Time(In Days)],
 CASE WHEN DATEDIFF(DAY, Order_Date, Ship_Date) >= 4 THEN 'Slow Delivery'
      WHEN DATEDIFF(DAY, Order_Date, Ship_Date) BETWEEN 1 AND 4 THEN 'Fast Delivery'
	  ELSE 'Same Day Delivery'
	  END AS 'Delivery Type'
 FROM Sales.Orders
 ORDER BY [Delivery Time(In Days)] DESC;

 -- Count of Delivery Types
 WITH Delivery_Types AS
 ( SELECT Order_ID, 
		DATEDIFF(DAY, Order_Date, Ship_Date) as [Delivery Time(In Days)],
 CASE WHEN DATEDIFF(DAY, Order_Date, Ship_Date) >= 4 THEN 'Slow Delivery'
      WHEN DATEDIFF(DAY, Order_Date, Ship_Date) BETWEEN 1 AND 4 THEN 'Fast Delivery'
	  ELSE 'Same Day Delivery'
	  END AS 'Delivery Type'
 FROM Sales.Orders
 )
 SELECT [Delivery Type], COUNT([Delivery Type]) AS 'Total Deliveries'
 FROM Delivery_Types
 GROUP BY [Delivery Type]
 ORDER BY [Total Deliveries] DESC;

 -- Total and Average Sales by Employees
 SELECT E.Sales_Rep_ID,
	   E.Sales_Rep, 
	   [Total sales] = SUM(Sales), 
	   [Average Sales] = AVG(Sales)
 FROM sales.Employees E
 JOIN sales.Orders O 
	   ON E.Sales_Rep_ID = O.Sales_Rep_ID
 GROUP BY E.Sales_Rep_ID,
			E.Sales_Rep
 ORDER BY [Total sales];