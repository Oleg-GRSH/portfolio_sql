-- SQL код для вывода аптек с оборотом от 1.8 миллионов

SELECT
    pharmacy_name,                   -- название аптеки
    SUM(price * count) AS total_turnover  -- общий оборот аптеки
FROM
    pharma_orders
GROUP BY
    pharmacy_name                    -- группировка по аптеке
HAVING
    SUM(price * count) >= 1800000   -- фильтрация аптек с оборотом >= 1.8 млн
ORDER BY
    total_turnover DESC;             -- сортировка по убыванию оборота
