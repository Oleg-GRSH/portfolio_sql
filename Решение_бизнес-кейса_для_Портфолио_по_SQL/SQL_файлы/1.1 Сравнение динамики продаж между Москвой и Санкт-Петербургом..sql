-- SQL код для сравнения динамики продаж по аптекам и месяцам в Москве и Санкт-Петербурге

WITH sales_moscow AS (
    SELECT
        pharmacy_name,
        DATE_TRUNC('month', report_date::timestamp) AS month,  -- Приведение к timestamp
        SUM(price * count) AS total_sales_moscow
    FROM
        pharma_orders
    WHERE
        city = 'Москва' -- фильтр по городу Москва
    GROUP BY
        pharmacy_name,
        month
),

sales_spb AS (
    SELECT
        pharmacy_name,
        DATE_TRUNC('month', report_date::timestamp) AS month,  -- Приведение к timestamp
        SUM(price * count) AS total_sales_spb
    FROM
        pharma_orders
    WHERE
        city = 'Санкт-Петербург' -- фильтр по городу Санкт-Петербург
    GROUP BY
        pharmacy_name,
        month
)

SELECT
    COALESCE(m.pharmacy_name, s.pharmacy_name) AS pharmacy_name,
    COALESCE(m.month, s.month) AS month,
    COALESCE(total_sales_moscow, 0) AS sales_moscow,
    COALESCE(total_sales_spb, 0) AS sales_spb,
    CASE 
        WHEN COALESCE(total_sales_spb, 0) = 0 THEN NULL
        ELSE ROUND(((COALESCE(total_sales_moscow, 0) - total_sales_spb) / total_sales_spb) * 100, 2)
    END AS percent_difference
FROM
    sales_moscow m
FULL OUTER JOIN
    sales_spb s
ON
    m.pharmacy_name = s.pharmacy_name AND m.month = s.month
ORDER BY
    pharmacy_name,
    month;
