-- Находим двух последних клиентов, совершивших покупки в каждой кампании
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
    first_purchase_date,
    -- Получаем клиента, который был на 1 шаг раньше (предыдущий по дате первой покупки)
    LAG(customer_id, 1) OVER (
        PARTITION BY campaign_id
        ORDER BY first_purchase_date DESC
    ) AS last_client_1,
    -- Получаем клиента, который был на 2 шага раньше
    LAG(customer_id, 2) OVER (
        PARTITION BY campaign_id
        ORDER BY first_purchase_date DESC
    ) AS last_client_2
FROM
    first_purchases
ORDER BY
    campaign_id,
    first_purchase_date DESC;




/*Объяснение:
Объяснение:
В CTE first_purchases для каждого клиента и кампании вычисляем дату его первой покупки.

В основном запросе сортируем клиентов по дате первой покупки в порядке убывания (последние сверху).

С помощью функции LAG получаем идентификаторы клиентов, которые были привлечены на 1 и 2 позиции раньше в рамках кампании.

В результате для каждой записи видим текущего клиента и двух предыдущих по времени привлечения.
*/