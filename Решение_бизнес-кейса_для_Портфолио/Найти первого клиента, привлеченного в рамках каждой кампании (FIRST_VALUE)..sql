-- Для каждой кампании находим первого клиента по дате первой покупки
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
    -- Получаем первого клиента в кампании по дате первой покупки с помощью FIRST_VALUE
    FIRST_VALUE(customer_id) OVER (
        PARTITION BY campaign_id
        ORDER BY first_purchase_date ASC
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    ) AS first_customer_id,
    -- Также можно получить дату первой покупки этого клиента
    FIRST_VALUE(first_purchase_date) OVER (
        PARTITION BY campaign_id
        ORDER BY first_purchase_date ASC
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    ) AS first_purchase_date
FROM
    first_purchases
ORDER BY
    campaign_id;

/*Объяснение:
В CTE first_purchases для каждого клиента и кампании вычисляем дату его первой покупки.

В основном запросе с помощью оконной функции FIRST_VALUE в каждой группе по campaign_id выбираем customer_id с минимальной датой покупки — то есть первого клиента.

Используем DISTINCT, чтобы вывести по одной записи на кампанию.

ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING гарантирует, что FIRST_VALUE берёт значение для всей группы.
*/