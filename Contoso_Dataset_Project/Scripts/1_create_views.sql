DROP VIEW IF EXISTS cohort_analysis;

CREATE VIEW public.cohort_analysis AS
WITH customer_revenue AS (
	SELECT
		s.customerkey,
		s.orderdate,
		SUM(s.quantity * s.netprice * s.exchangerate) AS total_net_revenue,
		COUNT(s.orderkey) AS num_order,
		MAX(c.countryfull) AS countryfull,
		MAX(c.age) AS age,
		MAX(c.givenname) AS givenname,
		MAX(c.surname) AS surname
	FROM
		sales s
	JOIN customer c ON
		c.customerkey = s.customerkey
	GROUP BY
		s.customerkey,
		s.orderdate
)
SELECT
	customerkey,
	orderdate,
	total_net_revenue,
	num_order,
	countryfull,
	age,
	CONCAT(TRIM(givenname), ' ', TRIM(surname)) AS full_name,
	MIN(cr.orderdate) OVER (
		PARTITION BY cr.customerkey
	) AS first_purchase_date,
	EXTRACT(YEAR FROM MIN(cr.orderdate) OVER (PARTITION BY cr.customerkey)) AS corhort_year
FROM
	customer_revenue cr
