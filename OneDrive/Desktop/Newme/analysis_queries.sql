SELECT
    plan,
    COUNT(*) AS active_customers,
    SUM(monthly_revenue) AS total_mrr,
    ROUND(AVG(monthly_revenue), 2) AS avg_revenue
FROM customers
WHERE is_churned = 'False'
GROUP BY plan
ORDER BY total_mrr DESC;

SELECT
    plan,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN is_churned = 'True' THEN 1 ELSE 0 END) AS churned,
    ROUND(
        100.0 * SUM(CASE WHEN is_churned = 'True' THEN 1 ELSE 0 END) / COUNT(*), 1
    ) AS churn_rate_pct
FROM customers
GROUP BY plan
ORDER BY churn_rate_pct DESC;

SELECT
    region,
    COUNT(*) AS customers,
    SUM(monthly_revenue) AS total_mrr,
    ROUND(AVG(nps_score), 1) AS avg_satisfaction
FROM customers
WHERE is_churned = 'False'
GROUP BY region
ORDER BY total_mrr DESC;

SELECT
    customer_id, company_name, plan,
    nps_score, features_used, support_tickets
FROM customers
WHERE
    is_churned = 'False'
    AND nps_score <= 4
    AND features_used <= 3
ORDER BY nps_score ASC
LIMIT 20;

SELECT
    plan,
    ROUND(AVG(
        julianday(churn_date) - julianday(signup_date)
    ), 0) AS avg_days_before_churn
FROM customers
WHERE is_churned = 'True'
GROUP BY plan
ORDER BY avg_days_before_churn;

SELECT
    CASE
        WHEN features_used <= 3 THEN 'Low (1-3)'
        WHEN features_used <= 7 THEN 'Medium (4-7)'
        ELSE 'High (8+)'
    END AS feature_usage_tier,
    COUNT(*) AS customers,
    ROUND(100.0 * SUM(CASE WHEN is_churned='True' THEN 1 ELSE 0 END) / COUNT(*), 1) AS churn_pct
FROM customers
GROUP BY 1
ORDER BY churn_pct DESC;