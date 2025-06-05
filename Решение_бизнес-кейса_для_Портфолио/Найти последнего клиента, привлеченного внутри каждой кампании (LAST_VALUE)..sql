-- Находим последнего клиента, привлеченного внутри каждой кампании
WITH first_purchases AS (
    SELECT
        campaign_id,
        customer_id,
        MIN(purchase_date) AS first_purchase_date -- дата первой покупки клиента в кампании
    FROM
        marketing_data
    GROUP BY
        campaign_id,
        customer_id
)

SELECT DISTINCT
    campaign_id,
    -- Используем FIRST_VALUE с обратной сортировкой по дате, чтобы получить последнего клиента
    FIRST_VALUE(customer_id) OVER (
        PARTITION BY campaign_id
        ORDER BY first_purchase_date DESC
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    ) AS last_customer_id,
    -- Дата последней покупки этого клиента в кампании
    FIRST_VALUE(first_purchase_date) OVER (
        PARTITION BY campaign_id
        ORDER BY first_purchase_date DESC
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    ) AS last_purchase_date
FROM
    first_purchases
ORDER BY
    campaign_id;





/*
Объяснение:
В CTE first_purchases для каждого клиента и кампании вычисляем дату его первой покупки.

В основном запросе с помощью FIRST_VALUE и сортировки по дате в обратном порядке (DESC) получаем клиента с самой поздней первой покупкой — то есть последнего привлечённого клиента.

ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING гарантирует, что функция смотрит на все строки в группе, а не только на текущую и предыдущие.

Используем DISTINCT, чтобы вывести по одной записи на кампанию.
*/