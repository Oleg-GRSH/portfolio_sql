-- SQL код для вывода топ-3 лекарств по объему продаж
-- Объем продаж = price * count

SELECT
    drug,                          -- название лекарства
    SUM(price * count) AS total_sales  -- общий объем продаж по лекарству
FROM
    pharma_orders
GROUP BY
    drug                           -- группировка по названию лекарства
ORDER BY
    total_sales DESC               -- сортировка по убыванию объема продаж
LIMIT 3;                          -- вывод только трех лидеров
