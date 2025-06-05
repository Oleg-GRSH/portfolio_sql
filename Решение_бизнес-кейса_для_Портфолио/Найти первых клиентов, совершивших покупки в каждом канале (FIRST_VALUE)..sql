-- Находим первых клиентов, совершивших покупки в каждом канале
WITH first_purchases AS (
    SELECT
        channel,
        customer_id,
        MIN(purchase_date) AS first_purchase_date -- дата первой покупки клиента в канале
    FROM
        marketing_data
    GROUP BY
        channel,
        customer_id
)

SELECT DISTINCT
    channel,
    -- Получаем первого клиента в каждом канале по дате первой покупки с помощью FIRST_VALUE
    FIRST_VALUE(customer_id) OVER (
        PARTITION BY channel
        ORDER BY first_purchase_date ASC
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    ) AS first_customer_id,
    -- Дату первой покупки этого клиента в канале
    FIRST_VALUE(first_purchase_date) OVER (
        PARTITION BY channel
        ORDER BY first_purchase_date ASC
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    ) AS first_purchase_date
FROM
    first_purchases
ORDER BY
    channel;


/*Объяснение:
Объяснение:
В CTE first_purchases для каждого клиента и канала вычисляем дату его первой покупки.

В основном запросе с помощью оконной функции FIRST_VALUE в каждой группе по channel выбираем customer_id с минимальной датой покупки — то есть первого клиента в канале.

Используем DISTINCT, чтобы вывести по одной записи на канал.

ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING гарантирует, что FIRST_VALUE берёт значение по всей группе.

Если хотите получить только одну строку на канал без дубликатов, можно обернуть запрос в подзапрос с фильтром по ROW_NUMBER() = 1. При необходимости помогу написать такой вариант!
*/