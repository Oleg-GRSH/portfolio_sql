-- SQL код для вывода аптек с оборотом более 1.8 миллиона

SELECT
    pharmacy_name,                                  -- название аптеки
    SUM(price * count) AS total_turnover            -- общий оборот аптеки
FROM
    pharma_orders
-- report_date преобразуем в timestamp, если потребуется для других задач:
-- , report_date::timestamp AS report_date_ts
GROUP BY
    pharmacy_name                                   -- группировка по аптеке
HAVING
    SUM(price * count) >= 1800000                   -- фильтр по обороту >= 1.8 млн
ORDER BY
    total_turnover DESC;                            -- сортировка по убыванию оборота
