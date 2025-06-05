WITH campaign_sums AS (
    SELECT 
        campaign_id,
        SUM(purchase_amount) AS total_purchase
    FROM marketing_data
    GROUP BY campaign_id
)

SELECT 
    campaign_id,
    total_purchase,
    NTILE(3) OVER (ORDER BY total_purchase DESC) AS purchase_group
FROM campaign_sums
ORDER BY purchase_group, campaign_id;