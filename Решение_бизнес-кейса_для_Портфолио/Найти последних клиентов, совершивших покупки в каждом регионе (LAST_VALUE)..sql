-- Находим последних клиентов, совершивших покупки в каждом регионе
WITH last_purchases AS (
    SELECT
        region,
        customer_id,
        MAX(purchase_date) AS last_purchase_date -- дата последней покупки клиента в регионе
    FROM
        marketing_data
    GROUP BY
        region,
        customer_id
)

SELECT DISTINCT
    region,
    -- Используем FIRST_VALUE с обратной сортировкой по дате, чтобы получить последнего клиента в регионе
    FIRST_VALUE(customer_id) OVER (
        PARTITION BY region
        ORDER BY last_purchase_date DESC
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    ) AS last_customer_id,
    -- Дата последней покупки этого клиента в регионе
    FIRST_VALUE(last_purchase_date) OVER (
        PARTITION BY region
        ORDER BY last_purchase_date DESC
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    ) AS last_purchase_date
FROM
    last_purchases
ORDER BY
    region;






/*
Объяснение:
В CTE last_purchases для каждого клиента и региона вычисляем дату его последней покупки.

В основном запросе с помощью оконной функции FIRST_VALUE и сортировки по дате в порядке убывания (DESC) выбираем клиента с самой поздней покупкой — фактически последнего клиента в регионе.

ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING гарантирует, что функция смотрит на все строки в группе.

DISTINCT позволяет вывести по одной записи на регион.
*/