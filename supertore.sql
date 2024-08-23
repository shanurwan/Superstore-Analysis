Data: https://www.kaggle.com/datasets/vivek468/superstore-dataset-final
  
#Market Basket analysis
  
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
