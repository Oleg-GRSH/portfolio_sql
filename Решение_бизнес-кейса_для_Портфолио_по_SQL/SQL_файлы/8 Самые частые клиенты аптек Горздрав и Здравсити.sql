-- SQL код для определения топ-10 самых частых клиентов аптек "Горздрав" и "Здравсити"

WITH gorzdrav_top_clients AS (
    SELECT
        c.customer_id,
        CONCAT_WS(' ', c.last_name, c.first_name, c.second_name) AS full_name,  -- объединение ФИО
        COUNT(po.order_id) AS orders_count                                      -- количество заказов
    FROM
        pharma_orders po
    JOIN
        customers c ON po.customer_id = c.customer_id
    WHERE
        po.pharmacy_name = 'Горздрав'                                          -- фильтр по аптеке "Горздрав"
    GROUP BY
        c.customer_id, c.last_name, c.first_name, c.second_name
    ORDER BY
        orders_count DESC                                                      -- сортировка по убыванию количества заказов
    LIMIT 10                                                                  -- топ-10 клиентов
),

zdravcity_top_clients AS (
    SELECT
        c.customer_id,
        CONCAT_WS(' ', c.last_name, c.first_name, c.second_name) AS full_name,  -- объединение ФИО
        COUNT(po.order_id) AS orders_count                                      -- количество заказов
    FROM
        pharma_orders po
    JOIN
        customers c ON po.customer_id = c.customer_id
    WHERE
        po.pharmacy_name = 'Здравсити'                                        -- фильтр по аптеке "Здравсити"
    GROUP BY
        c.customer_id, c.last_name, c.first_name, c.second_name
    ORDER BY
        orders_count DESC                                                      -- сортировка по убыванию количества заказов
    LIMIT 10                                                                  -- топ-10 клиентов
)

-- Объединяем результаты двух аптек
SELECT
    'Горздрав' AS pharmacy_name,
    customer_id,
    full_name,
    orders_count
FROM
    gorzdrav_top_clients

UNION ALL

SELECT
    'Здравсити' AS pharmacy_name,
    customer_id,
    full_name,
    orders_count
FROM
    zdravcity_top_clients;
