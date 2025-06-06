-- SQL код для вычисления накопленной суммы продаж по каждой аптеке с разбивкой по дате заказа

SELECT
    pharmacy_name,                          -- название аптеки
    report_date::timestamp AS report_date_ts,  -- преобразуем report_date в timestamp
    SUM(price * count) OVER (
        PARTITION BY pharmacy_name          -- разделение по аптеке
        ORDER BY report_date::timestamp     -- упорядочивание по дате заказа
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW  -- накопление от начала до текущей строки
    ) AS cumulative_sales                   -- накопленная сумма продаж
FROM
    pharma_orders
ORDER BY
    pharmacy_name,
    report_date_ts;
