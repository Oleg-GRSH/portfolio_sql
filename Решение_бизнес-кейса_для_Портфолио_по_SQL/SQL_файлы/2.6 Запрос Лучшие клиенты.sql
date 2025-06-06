-- SQL код для вывода топ-10 клиентов по общей сумме заказов

WITH client_totals AS (
    SELECT
        c.customer_id,
        c.first_name,
        c.last_name,
        c.second_name,
        SUM(po.price * po.count) AS total_spent
    FROM
        customers c
    JOIN
        pharma_orders po ON c.customer_id = po.customer_id
    -- report_date преобразуем в timestamp, если потребуется для других задач:
    -- , po.report_date::timestamp AS report_date_ts
    GROUP BY
        c.customer_id, c.first_name, c.last_name, c.second_name
),

ranked_clients AS (
    SELECT
        customer_id,
        first_name,
        last_name,
        second_name,
        total_spent,
        ROW_NUMBER() OVER (ORDER BY total_spent DESC) AS rank
    FROM
        client_totals
)

SELECT
    first_name,
    last_name,
    second_name,
    total_spent
FROM
    ranked_clients
WHERE
    rank <= 10
ORDER BY
    total_spent DESC;

