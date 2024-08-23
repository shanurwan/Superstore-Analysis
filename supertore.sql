#Data: https://www.kaggle.com/datasets/vivek468/superstore-dataset-final
  
#Market Basket analysis
#Calculate the frequency for a pair of products
	
WITH Info AS
(SELECT
	OrderList.orderid,
	FIS.subcategory
FROM
	(SELECT
		orderid,
		COUNT(subcategory) AS NumberofProducts
	FROM customer
	GROUP BY orderid
	HAVING COUNT(subcategory) >= 2) AS OrderList
JOIN customer AS FIS ON Orderlist.orderid = FIS.orderid)

SELECT
	Info1.subcategory AS Product1,
	Info2.subcategory AS Product2,
	COUNT(*) AS Frequency
FROM Info AS Info1
JOIN Info AS Info2 ON Info1.orderid = Info2.orderid
WHERE Info1.subcategory != Info2.subcategory
  AND Info1.subcategory < Info2.subcategory
GROUP BY
	Info1.subcategory,
	Info2.subcategory
ORDER BY COUNT(*);

#Show only the pair with the highest frequency for each category
	
WITH Info AS (
    SELECT
        o.orderid,
        p.subcategory
    FROM customer o
    JOIN customer p ON o.orderid = p.orderid
    WHERE p.subcategory IS NOT NULL
    GROUP BY o.orderid, p.subcategory
    HAVING COUNT(p.subcategory) >= 2
),

PairFrequencies AS (
    SELECT
        Info1.subcategory AS Product1,
        Info2.subcategory AS Product2,
        COUNT(*) AS Frequency
    FROM Info AS Info1
    JOIN Info AS Info2 ON Info1.orderid = Info2.orderid
    WHERE Info1.subcategory != Info2.subcategory
      AND Info1.subcategory < Info2.subcategory
    GROUP BY
        Info1.subcategory,
        Info2.subcategory
),

MaxFrequencies AS (
    SELECT
        Product1,
        MAX(Frequency) AS MaxFrequency
    FROM PairFrequencies
    GROUP BY Product1
)

SELECT
    pf.Product1,
    pf.Product2,
    pf.Frequency
FROM PairFrequencies pf
JOIN MaxFrequencies mf
ON pf.Product1 = mf.Product1 AND pf.Frequency = mf.MaxFrequency
ORDER BY pf.Product1;
