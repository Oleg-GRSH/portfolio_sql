-- Для каждой кампании выбираем 3-х первых клиентов по дате первой покупки
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

SELECT
    campaign_id,
    customer_id,
    first_purchase_date
FROM (
    SELECT
        campaign_id,
        customer_id,
        first_purchase_date,
        ROW_NUMBER() OVER (
            PARTITION BY campaign_id
            ORDER BY first_purchase_date ASC
        ) AS rn -- нумерация клиентов внутри кампании по дате первой покупки
    FROM
        first_purchases
) ranked
WHERE rn <= 3 -- выбираем только первых трех клиентов
ORDER BY
    campaign_id,
    rn;
