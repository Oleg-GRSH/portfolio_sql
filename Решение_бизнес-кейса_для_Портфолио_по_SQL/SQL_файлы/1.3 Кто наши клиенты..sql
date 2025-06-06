-- SQL код для анализа клиентов по возрастным и гендерным группам с подсчетом доли продаж

WITH customer_sales AS (
    SELECT
        c.customer_id,
        c.gender,
        EXTRACT(YEAR FROM AGE(CURRENT_DATE, c.date_of_birth::date)) AS age,  -- приведение к date
        po.price,
        po.count,
        po.report_date::timestamp AS report_date_ts
    FROM
        customers c
    JOIN
        pharma_orders po ON c.customer_id = po.customer_id
),

grouped_sales AS (
    SELECT
        CASE
            WHEN gender = 'М' AND age < 30 THEN 'Мужчины младше 30'
            WHEN gender = 'М' AND age BETWEEN 30 AND 45 THEN 'Мужчины 30-45'
            WHEN gender = 'М' AND age > 45 THEN 'Мужчины старше 45'
            WHEN gender = 'Ж' AND age < 30 THEN 'Женщины младше 30'
            WHEN gender = 'Ж' AND age BETWEEN 30 AND 45 THEN 'Женщины 30-45'
            WHEN gender = 'Ж' AND age > 45 THEN 'Женщины старше 45'
            ELSE 'Прочие'
        END AS customer_group,
        SUM(price * count) AS total_sales
    FROM
        customer_sales
    GROUP BY
        customer_group
)

SELECT
    customer_group,
    total_sales,
    ROUND(total_sales * 100.0 / SUM(total_sales) OVER (), 2) AS sales_share_percent  -- доля продаж по группе в процентах
FROM
    grouped_sales
ORDER BY
    total_sales DESC;
