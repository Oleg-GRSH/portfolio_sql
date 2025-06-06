-- SQL код для анализа продаж лекарств, начинающихся с "аква"

WITH filtered_drugs AS (
    SELECT
        LOWER(drug) AS drug_lower,                   -- приводим название лекарства к нижнему регистру
        price,
        count,
        report_date::timestamp AS report_date_ts    -- преобразуем report_date к типу timestamp (если потребуется в дальнейшем)
    FROM
        pharma_orders
    WHERE
        LOWER(drug) LIKE 'аква%'                      -- фильтрация по названию, начинающемуся на "аква"
)

SELECT
    drug_lower AS drug_name,                          -- название лекарства в нижнем регистре
    SUM(price * count) AS total_sales,                -- общий объем продаж по препарату
    ROUND(SUM(price * count) * 100.0 / SUM(SUM(price * count)) OVER (), 2) AS sales_share_percent  -- доля в общем объеме продаж
FROM
    filtered_drugs
GROUP BY
    drug_lower
ORDER BY
    total_sales DESC;                                 -- сортировка по убыванию объема продаж
