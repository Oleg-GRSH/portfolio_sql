-- SQL код для вычисления накопленной суммы заказов по каждому клиенту с объединением ФИО

SELECT
    c.customer_id,
    CONCAT_WS(' ', c.last_name, c.first_name, c.second_name) AS full_name,  -- объединение ФИО в одно поле
    po.report_date::timestamp AS report_date_ts,                           -- преобразование report_date в timestamp
    SUM(po.price * po.count) OVER (
        PARTITION BY c.customer_id                                         -- разделение по клиенту
        ORDER BY po.report_date::timestamp                                 -- упорядочивание по дате заказа
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW                   -- накопление от начала до текущей строки
    ) AS cumulative_spent                                                  -- накопленная сумма заказов
FROM
    customers c
JOIN
    pharma_orders po ON c.customer_id = po.customer_id
ORDER BY
    c.customer_id,
    report_date_ts;

