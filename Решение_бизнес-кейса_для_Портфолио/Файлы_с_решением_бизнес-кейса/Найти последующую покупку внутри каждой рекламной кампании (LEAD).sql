SELECT
    customer_id,
    campaign_id,
    purchase_amount,
    purchase_date,
    LEAD(purchase_date) OVER (
        PARTITION BY customer_id, campaign_id 
        ORDER BY purchase_date
    ) AS next_purchase_date,
    LEAD(purchase_amount) OVER (
        PARTITION BY customer_id, campaign_id 
        ORDER BY purchase_date
    ) AS next_purchase_amount
FROM marketing_data
ORDER BY customer_id, campaign_id, purchase_date;

/*
Объяснение  
- Используем функцию LEAD, чтобы получить дату и сумму следующей покупки для каждого 
клиента внутри конкретной кампании.  
- Окно разбивается по customer_id и campaign_id для работы по каждой 
цепочке покупок клиента в рамках одной кампании.  
- Сортировка по purchase_date идет по времени покупок, чтобы корректно 
определить следующую покупку.  

В результате вы получите исходные покупки с дополнением 
полей следующей покупки внутри той же кампании для каждого клиента.
*/