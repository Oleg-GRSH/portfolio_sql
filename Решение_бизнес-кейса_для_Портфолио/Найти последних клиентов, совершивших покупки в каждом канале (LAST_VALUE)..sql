-- Находим последних клиентов, совершивших покупки в каждом канале
WITH last_purchases AS (
    SELECT
        channel,
        customer_id,
        MAX(purchase_date) AS last_purchase_date -- дата последней покупки клиента в канале
    FROM
        marketing_data
    GROUP BY
        channel,
        customer_id
)

SELECT DISTINCT
    channel,
    -- Получаем последнего клиента в каждом канале по дате последней покупки с помощью LAST_VALUE
    LAST_VALUE(customer_id) OVER (
        PARTITION BY channel
        ORDER BY last_purchase_date ASC
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    ) AS last_customer_id,
    -- Дату последней покупки этого клиента в канале
    LAST_VALUE(last_purchase_date) OVER (
        PARTITION BY channel
        ORDER BY last_purchase_date ASC
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    ) AS last_purchase_date
FROM
    last_purchases
ORDER BY
    channel;



/*Объяснение:
В CTE last_purchases для каждого клиента и канала вычисляем дату его последней покупки.

В основном запросе с помощью оконной функции LAST_VALUE в каждой группе по channel выбираем customer_id с максимальной датой покупки — то есть последнего клиента.

Используем DISTINCT, чтобы вывести по одной записи на канал.

ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING гарантирует, что LAST_VALUE берёт значение по всей группе, а не только до текущей строки.

Важно
Функция LAST_VALUE в PostgreSQL по умолчанию смотрит на текущую и предыдущие строки, поэтому необходимо явно указать рамки окна ROWS BETWEEN UNBOUNDED PRECEDING 
AND UNBOUNDED FOLLOWING, чтобы получить значение из последней строки группы.
*/