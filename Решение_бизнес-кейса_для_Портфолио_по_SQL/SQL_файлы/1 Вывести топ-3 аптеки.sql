-- SQL код для вывода топ-3 аптек по объему продаж
-- Объем продаж = price * count

SELECT
    pharmacy_name,                -- название аптеки
    SUM(price * count) AS total_sales  -- общий объем продаж
FROM
    pharma_orders
GROUP BY
    pharmacy_name                 -- группировка по названию аптеки
ORDER BY
    total_sales DESC              -- сортировка по убыванию объема продаж
LIMIT 3;                         -- вывод только трех лидеров