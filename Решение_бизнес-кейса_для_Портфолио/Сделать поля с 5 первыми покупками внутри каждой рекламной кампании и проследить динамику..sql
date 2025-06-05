-- Получаем первые 5 покупок внутри каждой рекламной кампании
WITH ranked_purchases AS (
    SELECT
        campaign_id,
        customer_id,
        purchase_amount,
        purchase_date,
        region,
        channel,
        age,
        gender,
        ROW_NUMBER() OVER (
            PARTITION BY campaign_id
            ORDER BY purchase_date ASC
        ) AS purchase_rank -- нумерация покупок по дате внутри кампании
    FROM
        marketing_data
)

SELECT
    campaign_id,
    purchase_rank,        -- порядковый номер покупки внутри кампании (1..5)
    customer_id,
    purchase_amount,
    purchase_date,
    region,
    channel,
    age,
    gender
FROM
    ranked_purchases
WHERE
    purchase_rank <= 5    -- выбираем только первые 5 покупок
ORDER BY
    campaign_id,
    purchase_rank;







/*
Объяснение:
В CTE ranked_purchases для каждой кампании нумеруем покупки по возрастанию даты (purchase_date).

В основном запросе выбираем только первые 5 покупок (purchase_rank <= 5).

Выводим все поля для анализа и прослеживания динамики первых покупок в каждой кампании.

Сортируем результат по campaign_id и порядковому номеру покупки, чтобы видеть хронологию.
*/