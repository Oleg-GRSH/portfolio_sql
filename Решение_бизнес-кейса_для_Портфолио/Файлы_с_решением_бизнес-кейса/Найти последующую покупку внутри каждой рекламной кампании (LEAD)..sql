SELECT 
  customer_id, 
  campaign_id, 
  purchase_amount, 
  purchase_date, 
  region, 
  channel, 
  age, 
  gender, 
  LEAD(purchase_date) OVER (
    PARTITION BY campaign_id 
    ORDER BY 
      purchase_date
  ) AS next_purchase_date, 
  LEAD(purchase_amount) OVER (
    PARTITION BY campaign_id 
    ORDER BY 
      purchase_date
  ) AS next_purchase_amount 
FROM 
  marketing_data 
ORDER BY 
  campaign_id, 
  purchase_date;


/*
Объяснение
LEAD(purchase_date) OVER (...): возвращает дату следующей покупки в рамках той же кампании.

PARTITION BY campaign_id: разбивает данные на группы по каждой рекламной кампании.

ORDER BY purchase_date: определяет порядок покупок внутри кампании.

Аналогично, LEAD(purchase_amount) возвращает сумму следующей покупки.

Результат
В результате вы получите таблицу, где для каждой строки будут указаны дата и 
сумма следующей покупки в рамках той же рекламной кампании. Если следующей покупки нет, значения будут NULL.
*/