SELECT
	ca.corhort_year,
	COUNT(DISTINCT ca.customerkey) AS total_customers,
	SUM(ca.total_net_revenue) AS total_revenue,
	SUM(ca.total_net_revenue) / COUNT(DISTINCT ca.customerkey) AS customer_revenue
FROM
	cohort_analysis ca
WHERE
	ca.orderdate = ca.first_purchase_date
GROUP BY
	ca.corhort_year