WITH customer_purchase AS (
	SELECT 
		ca.customerkey,
		ca.corhort_year,
		MAX(ca.full_name) AS full_name,
		MAX(ca.first_purchase_date) AS first_purchase_date,
		MAX(ca.orderdate) AS last_purchase_date
	FROM
		cohort_analysis ca
	GROUP BY
		ca.corhort_year, ca.customerkey
	ORDER BY
		ca.customerkey
),
last_purchase_date_for_all AS (
	SELECT
		MAX(ca.orderdate) AS last_date
	FROM
		cohort_analysis ca
),
customer_status AS (
	SELECT
		clp.*,
		CASE
			WHEN clp.last_purchase_date < lpd.last_date - INTERVAL '6 months' THEN 'Inactive'
			ELSE 'Active'
		END AS customer_status
	FROM
		customer_purchase clp,
		last_purchase_date_for_all lpd
	WHERE
		--remove customer that exists less then 6 months to avoid bias
		clp.first_purchase_date < lpd.last_date - INTERVAL '6 months'
	ORDER BY
		clp.last_purchase_date DESC,
		clp.customerkey
)
SELECT
	cs.corhort_year ,
	cs.customer_status,
	COUNT(cs.customerkey) AS num_customers,
	ROUND((100* COUNT(cs.customerkey) / SUM(COUNT(cs.customerkey)) OVER(PARTITION BY cs.corhort_year)), 2) AS status_percentage
FROM
	customer_status cs
GROUP BY
	cs.corhort_year, cs.customer_status
