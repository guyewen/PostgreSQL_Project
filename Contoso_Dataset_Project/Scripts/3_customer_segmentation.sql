WITH customer_ltv AS (
	SELECT
		ca.customerkey,
		ca.full_name,
		SUM(ca.total_net_revenue) AS total_ltv
	FROM
		cohort_analysis ca
	GROUP BY
		customerkey,
		full_name
),
customer_segments AS (
	SELECT
		PERCENTILE_CONT(0.25) WITHIN GROUP (
		ORDER BY
			total_ltv
		) AS ltv_25_percent,
		PERCENTILE_CONT(0.75) WITHIN GROUP (
		ORDER BY
			total_ltv
		) AS ltv_75_percent
	FROM
		customer_ltv
),
segment_values AS (
	SELECT
		cl.*,
		CASE
			WHEN cl.total_ltv < cs.ltv_25_percent THEN '1 - Low-Value'
			WHEN cl.total_ltv > cs.ltv_75_percent THEN '3 - High-Value'
			ELSE '2 - Mid-Value'
		END AS customer_level
	FROM
		customer_ltv cl,
		customer_segments cs
)
SELECT
	sv.customer_level,
	SUM(sv.total_ltv) AS total_ltv,
	COUNT(customerkey) AS customer_count,
	SUM(total_ltv) / COUNT(customerkey) AS avg_ltv
FROM
	segment_values sv
GROUP BY
	sv.customer_level
ORDER BY
	sv.customer_level DESC
