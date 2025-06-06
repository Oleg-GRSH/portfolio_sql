-- SQL код для подсчета количества уникальных клиентов в каждой аптеке

SELECT
    po.pharmacy_name,                     -- название аптеки из таблицы заказов
    COUNT(DISTINCT po.customer_id) AS unique_customers  -- количество уникальных клиентов
FROM
    pharma_orders po
JOIN
    customers c ON po.customer_id = c.customer_id  -- соединение с таблицей клиентов по customer_id
GROUP BY
    po.pharmacy_name                      -- группировка по аптеке
ORDER BY
    unique_customers DESC;                -- сортировка по убыванию количества клиентов
