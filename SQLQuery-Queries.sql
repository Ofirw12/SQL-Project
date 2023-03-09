-- First Query--
SELECT Month=DATENAME(Month,O.DATE), [Monthly Revenue]=SUM(D.Cost)
FROM ORDERS AS O JOIN Carts AS C ON O.Cart=C.[Cart ID] JOIN [Socks Saved To Carts] AS S ON S.Cart=C.[Cart ID] JOIN Designs AS D ON D.[Sock ID]=S.[Sock ID] AND D.[Design ID]=S.[Design ID]
WHERE YEAR(O.Date)=2009
GROUP BY DATENAME(MONTH,O.DATE)
HAVING SUM(D.Cost)>30
ORDER BY 2 DESC

--Second Query--
SELECT TOP 5 C.Username,Count(DISTINCT O.[Order ID]) AS [Total Number of Orders]
FROM Customers AS C JOIN [Customer's Payment Info] AS I ON C.Username=I.Username JOIN Orders AS O ON I.[Credit Number]=O.[Credit Card]
WHERE Country='Germany'
GROUP BY C.Username
ORDER BY 2 DESC

--First Nested Query--
SELECT [Year] = YEAR(O.DATE), Revenue = SUM(D.COST)
FROM ORDERS AS O JOIN Carts AS C ON O.Cart=C.[Cart ID] JOIN [Socks Saved To Carts] AS S ON S.Cart=C.[Cart ID] JOIN Designs AS D ON D.[Sock ID]=S.[Sock ID] AND D.[Design ID]=S.[Design ID]
GROUP BY YEAR(O.DATE)
HAVING SUM(D.COST)> (
	SELECT  SUM(D.Cost)/COUNT(DISTINCT YEAR(O.DATE))
	FROM ORDERS AS O JOIN Carts AS C ON O.Cart=C.[Cart ID] JOIN [Socks Saved To Carts] AS S ON S.Cart=C.[Cart ID] JOIN Designs AS D ON D.[Sock ID]=S.[Sock ID] AND D.[Design ID]=S.[Design ID]
	)
ORDER BY SUM(D.COST) DESC

--Second Nested Query--
SELECT SO.Type, [Number of orders] = COUNT(*)
FROM ORDERS AS O JOIN Carts AS C ON O.Cart=C.[Cart ID] 
JOIN Customers AS CU ON C.Username = CU.Username 
JOIN [Socks Saved To Carts] AS S ON S.Cart=C.[Cart ID] 
JOIN Socks AS SO ON SO.[Sock ID]= S.[Sock ID]
WHERE CU.Country IN (
	SELECT TOP 5 CU.Country
	FROM ORDERS AS O JOIN Carts AS C ON O.Cart=C.[Cart ID] JOIN Customers AS CU ON C.Username = CU.Username
	GROUP BY CU.Country
	ORDER BY COUNT(O.[Order ID])
	)
GROUP BY SO.Type

--First Complex Nested Query--
DELETE FROM [Design Uploaded Photos] 
WHERE PHOTO IN (
       SELECT Photo
       FROM [Design Uploaded Photos] AS D 
		JOIN [Socks Saved To Carts] AS S ON D.[Sock ID]=S.[Sock ID] AND D.[Design ID]=S.[Design ID] 
		JOIN Orders AS O ON S.Cart=O.Cart
       WHERE YEAR(O.Date) < 2001
)

--Second Complex Nested Query--
SELECT C.Username, C.City
FROM Customers AS C
WHERE C.City IN (
					SELECT TOP 3 C.City
					FROM Customers AS C JOIN Carts AS CA ON C.Username=CA.Username JOIN Orders AS O ON CA.[Cart ID]=O.Cart
					GROUP BY C.City 
					ORDER BY COUNT(*) DESC
				)
INTERSECT 
SELECT C.Username, C.City
FROM Customers AS C JOIN Carts AS CA ON C.Username=CA.Username JOIN Orders AS O ON CA.[Cart ID]=O.Cart
WHERE MONTH(O.DATE)> 6 AND YEAR(O.DATE) = 2013

--VIEW--
--DROP VIEW v_IncomeComparison
CREATE VIEW v_IncomeComparison AS
SELECT DISTINCT Year=YEAR(O.Date),
	Month=MONTH(O.Date),
	[Monthly Income] = SUM(D.Cost) OVER
		(PARTITION BY MONTH(O.Date),YEAR(O.Date)),
	[Last Year Monthly Income] =ISNULL((SELECT DISTINCT SUM(D.Cost) OVER
		(PARTITION BY YEAR(Ord.Date) ORDER BY MONTH(Ord.Date))
		FROM Orders AS Ord
			JOIN Carts AS C ON C.[Cart ID] = Ord.[Cart]
			JOIN [Socks Saved To Carts] AS SC ON SC.Cart =  C.[Cart ID]
JOIN Designs AS D ON D.[Sock ID] = SC.[Sock ID] AND D.[Design ID] = SC.[Design ID]
WHERE YEAR(Ord.Date)=YEAR(O.Date)-1 AND Month(O.Date)=Month(Ord.Date)),0),
	[Income Change in %]=ISNULL(ROUND(100*SUM(D.Cost) OVER
		(PARTITION BY MONTH(O.Date),YEAR(O.Date))/
		(SELECT DISTINCT SUM(D.Cost) OVER
		(PARTITION BY YEAR(Ord.Date) ORDER BY MONTH(Ord.Date))
		FROM Orders AS Ord
			JOIN Carts AS C ON c.[Cart ID] = Ord.[Cart]
			JOIN [Socks Saved To Carts] AS SC ON SC.Cart = C.[Cart ID]
			JOIN Designs AS D ON D.[Sock ID] = SC.[Sock ID] AND D.[Design ID] = SC.[Design ID]
WHERE YEAR(Ord.Date)=YEAR(O.Date)-1 AND Month(O.Date)=Month(Ord.Date)),0),0)
FROM Orders AS O
	JOIN Carts AS C ON c.[Cart ID] = O.[Cart]
	JOIN [Socks Saved To Carts] AS SC ON SC.Cart = C.[Cart ID]
	JOIN Designs AS D ON D.[Sock ID] = SC.[Sock ID] AND D.[Design ID] = SC.[Design ID]

SELECT * FROM v_IncomeComparison
WHERE Year=2012 AND Month=3

--First Function-- 

CREATE FUNCTION LastPurchase (@INPUT_Username VARCHAR(20))
RETURNS DATE 
AS
	BEGIN 
	DECLARE @OUTPUT DATE
		SELECT @OUTPUT = MAX(O.Date)
		FROM Customers  AS CU
		JOIN Carts AS CA ON CU.Username =CA.Username
		JOIN Orders AS O ON O.Cart = CA.[Cart ID]
		WHERE CU.Username = @INPUT_Username 
	RETURN @OUTPUT
	END

SELECT Username , LastPurchase = dbo.LastPurchase(Username)
FROM Customers

--Second Function--
--DROP FUNCTION BestSellerByCountry
CREATE FUNCTION BestSellerByCountry (@INPUT INT)
RETURNS TABLE
AS RETURN
	SELECT C.Country,SO.[Sock ID],[Number Of Orders]=COUNT(DISTINCT O.[Order ID])
	FROM Customers AS C JOIN Carts AS CA ON C.Username=CA.Username
	JOIN Orders AS O ON O.Cart=CA.[Cart ID]
	JOIN [Socks Saved To Carts] AS SO ON SO.Cart=CA.[Cart ID]
	JOIN Socks AS S ON S.[Sock ID]=SO.[Sock ID]
	WHERE YEAR(O.Date)=@INPUT
	GROUP BY C.Country,SO.[Sock ID]

SELECT *
FROM dbo.BestSellerByCountry(2009)
ORDER BY 1,3 DESC

-- Trigger--
--DROP TABLE [Yearly Revenues]
CREATE TABLE [Yearly Revenues](
Year INT NOT NULL,
Revenue MONEY,
CONSTRAINT PK_YRevenues PRIMARY KEY (Year)
)
INSERT INTO [Yearly Revenues]
	SELECT YEAR(O.Date),SUM(D.Cost)
	FROM Orders AS O JOIN Carts AS C ON O.Cart=C.[Cart ID]
		JOIN [Socks Saved To Carts] AS SO ON SO.Cart=C.[Cart ID]
		JOIN Designs AS D ON D.[Design ID]=SO.[Design ID] AND D.[Sock ID]=SO.[Sock ID]
	GROUP BY YEAR(O.Date)
--DROP TRIGGER UpdateRevenue
CREATE TRIGGER UpdateRevenue
		ON Orders
		FOR INSERT
		AS
		UPDATE [Yearly Revenues]
		SET Revenue = ISNULL(Revenue,0) + (SELECT D.Cost FROM INSERTED AS I JOIN Carts AS C ON I.Cart=C.[Cart ID]
											JOIN [Socks Saved To Carts] AS SO ON SO.Cart=C.[Cart ID]
											JOIN Designs AS D ON D.[Design ID]=SO.[Design ID] AND D.[Sock ID]=SO.[Sock ID]
											WHERE YEAR(I.Date)=[Yearly Revenues].Year)
		WHERE [Yearly Revenues].Year IN (SELECT YEAR(Date) FROM INSERTED)


INSERT INTO Orders VALUES (99999999,'02-03-2004','1078 8773 8940 1661',7492)
DELETE FROM Orders WHERE [Order ID]=99999999
	
SELECT * FROM [Yearly Revenues]

--SP--
--DROP PROCEDURE SP_Best_Customers
CREATE PROCEDURE SP_Best_Customers  @INPUT_YEAR INT 
	AS BEGIN 
	IF(SELECT Object_ID ('Best_Customers')) IS NOT NULL DROP TABLE Best_Customers 
		CREATE TABLE Best_Customers (
		Username VARCHAR(20),
		[Total Payment] MONEY,
		[Number of Orders] INT
		)
	INSERT INTO BEST_Customers
		SELECT TOP 10  CU.Username, SUM(D.Cost), COUNT(DISTINCT(O.[Order ID]))
		FROM Customers  AS CU
			JOIN Carts AS CA ON CU.Username =CA.Username
			JOIN Orders AS O ON O.Cart = CA.[Cart ID]
			JOIN [Socks Saved To Carts] AS SO ON SO.Cart=CA.[Cart ID]
			JOIN Designs AS D ON D.[Design ID]=SO.[Design ID]
AND D.[Sock ID]=SO.[Sock ID]
		WHERE YEAR(O.Date) >=@INPUT_YEAR
		GROUP BY CU.Username 
		ORDER BY SUM(D.Cost) DESC
		END

	EXECUTE	SP_BEST_Customers 	2005
	SELECT 	* 	FROM 	Best_Customers


--First Window Function-- 

SELECT Username, Year = YEAR(Date),
[Member Since] = YEAR(FIRST_VALUE(Date) OVER (PARTITION BY Username ORDER BY Date)),
[Total Orders],
[Total Orders Value],
[Number Of Orders Per Year],
[Yearly Order Value],
[Yearly Rank By Number Of Orders]= DENSE_RANK() OVER (PARTITION BY YEAR(Date) ORDER BY [Number Of Orders Per Year] DESC)
FROM (SELECT DISTINCT C.Username, O.Date,
			[Number Of Orders Per Year]= COUNT(O.[Order ID]) OVER (PARTITION BY YEAR(O.Date) ORDER BY C.Username),
			[Yearly Order Value]= SUM(D.Cost) OVER (PARTITION BY YEAR(O.Date) ORDER BY C.Username),
			[Total Orders]= COUNT (O.[Order ID]) OVER (ORDER BY C.Username),
			[Total Orders Value] = SUM(D.Cost) OVER (ORDER BY C.Username)
		FROM Customers AS C JOIN Carts AS CA ON CA.Username=C.Username
			JOIN Orders AS O ON O.Cart=CA.[Cart ID]
			JOIN [Socks Saved To Carts] AS SO ON CA.[Cart ID]=SO.Cart
			JOIN Designs AS D ON D.[Sock ID]=SO.[Sock ID]
			AND D.[Design ID]=SO.[Design ID]
	) AS V
	


--Second Window Function--
SELECT City,Year,
	[Number Of Orders Per Year],
	[Yearly Order Value],
	[Yearly Value Quarter]= NTILE(4) OVER (PARTITION BY Year ORDER BY [Number Of Orders Per Year] DESC),
	[Yearly Leading City] = ISNULL(
							LEAD(City) OVER(PARTITION BY Year ORDER BY [Number Of Orders Per Year])
							,'-')
FROM	(SELECT DISTINCT C.City, Year=YEAR(O.Date),
			[Number Of Orders Per Year]= COUNT(O.[Order ID]) OVER (PARTITION BY Year(O.Date) ORDER BY C.City ),
			[Yearly Order Value]= SUM(D.Cost) OVER (PARTITION BY YEAR(O.Date) ORDER BY C.City),
			[Total Orders]= COUNT(O.[Order ID]) OVER (ORDER BY C.City),
			[Total Orders Value] = SUM(D.Cost) OVER (ORDER BY C.City)
		FROM Customers AS C JOIN Carts AS CA ON CA.Username=C.Username
			JOIN Orders AS O ON O.Cart=CA.[Cart ID]
			JOIN [Socks Saved To Carts] AS SO ON CA.[Cart ID]=SO.Cart
			JOIN Designs AS D ON D.[Sock ID]=SO.[Sock ID]
			AND D.[Design ID]=SO.[Design ID]
		) AS V

--Mix Of Functions--
---------------VIEW------------------------	
---DROP VIEW V_NUM_ORDER
CREATE VIEW V_NUM_ORDER AS
	SELECT [Order COUNT]=COUNT(distinct O.[Order ID]),
	cu.Username
	FROM Customers  AS CU
		JOIN Carts AS CA ON CU.Username =CA.Username
		JOIN Orders AS O ON O.Cart = CA.[Cart ID] 
		GROUP BY CU.Username 

--SELECT * FROM V_NUM_ORDER



---------------SP------------------------	

--DROP PROCEDURE SP_Top_Returning_Customers

CREATE PROCEDURE SP_Top_Returning_Customers  @INPUT VARCHAR(20) 
AS  
	SELECT DISTINCT 	
		CU.Country ,
		CU.Username,
		[Order Count],
		[Rank by Country]=  DENSE_RANK() OVER(PARTITION BY Country ORDER BY ( [Order COUNT]) DESC)

	FROM Customers  AS CU
		JOIN Carts AS CA ON CU.Username =CA.Username
		JOIN V_NUM_ORDER  AS V ON V.Username = CU.Username
		JOIN Orders AS O ON O.Cart = CA.[Cart ID]
		JOIN [Socks Saved To Carts] AS SO ON SO.Cart=CA.[Cart ID]
		JOIN Designs AS D ON D.[Design ID]=SO.[Design ID] AND D.[Sock ID]=SO.[Sock ID]
	WHERE Country = @INPUT AND [Order Count]>=2
		
--EXECUTE  dbo.SP_Top_Returning_Customers 'GERMANY' 

--WITH--
WITH 
	Carts_Not_Bought AS 
		(SELECT  C.[Cart ID] ,CU.Username 
		FROM Carts AS C JOIN Customers AS CU ON C.Username = CU.Username
		EXCEPT
		SELECT C.[Cart ID] ,CU.Username 
		FROM  Carts AS C JOIN Customers AS CU ON C.Username = CU.Username
			JOIN ORDERS AS O ON C.[Cart ID] =O.Cart
		),

	Designs_Not_Bought_From_Cart AS
		(SELECT CU.Username,CN.[Cart ID],
			CU.Country,SUM_COST=SUM(D.Cost)
		FROM Carts_not_bought AS CN JOIN [Socks Saved To Carts] AS S ON S.Cart=CN.[Cart ID]
			JOIN Designs AS D ON D.[Sock ID] =S.[Sock ID] AND D.[Design ID] = S.[Design ID]
			JOIN Customers AS CU ON CN.Username = CU.Username
		GROUP BY CU.Username,CN.[Cart ID],CU.Country
		),

	Summary_Per_Country AS 
		(SELECT C.Country,
			SUM_COST_Country =SUM(DC.SUM_COST),
			COUNT_COST =COUNT(DISTINCT DC.SUM_COST),
			AVG_COST =AVG(DC.SUM_COST),
			MAX_COST = MAX(DC.SUM_COST),
			MIN_COST = MIN(DC.SUM_COST)
		FROM [Designs_Not_Bought_From_Cart] AS DC
			JOIN Customers AS C ON DC.Username = C.Username
		GROUP BY C.Country
		),

	Total_Carts AS 
		(SELECT C.Username,
			COUNT_CART=COUNT(C.[Cart ID]),
			TOTAL_COST = SUM(D.COST)
		FROM Carts AS C JOIN [Socks Saved To Carts] AS SD ON C.[Cart ID] = SD.Cart
			JOIN Designs AS D ON D.[Design ID] = SD.[Design ID] AND SD.[Sock ID]=D.[Sock ID]
		WHERE C.Username IS NOT NULL
		GROUP BY C.Username
		)

SELECT DN.Username,
	[Loss Per User]=DN.SUM_COST,
	[Total User's Carts Value]=TC.TOTAL_COST,
	[User Loss Percentage]=DN.SUM_COST/TC.TOTAL_COST*100,
	[Loss Per Country]=SPC.SUM_COST_Country,
	[Average Loss Per Country]=SPC.AVG_COST,
	[Biggest Loss Per Country]=SPC.MAX_COST,
	[User Loss Percentage From Biggest Loss]=DN.SUM_COST/SPC.MAX_COST*100,
	[Smallest Loss by Country]=SPC.MIN_COST
FROM Designs_Not_Bought_From_Cart AS DN
	JOIN Summary_Per_Country AS SPC ON SPC.Country =DN.Country
	JOIN Total_carts AS TC ON TC.Username = DN.Username
