-- SQL код для вывода топ-10 клиентов по общей сумме заказов

SELECT
    c.first_name,                           -- имя клиента
    c.last_name,                            -- фамилия клиента
    c.second_name,                         -- отчество клиента
    SUM(po.price * po.count) AS total_spent  -- общая сумма заказов клиента
FROM
    customers c
JOIN
    pharma_orders po ON c.customer_id = po.customer_id  -- соединение таблиц по customer_id
GROUP BY
    c.customer_id, c.first_name, c.last_name, c.second_name  -- группировка по клиенту
ORDER BY
    total_spent DESC                       -- сортировка по убыванию суммы заказов
LIMIT 10;                                 -- вывод топ-10 клиентов
