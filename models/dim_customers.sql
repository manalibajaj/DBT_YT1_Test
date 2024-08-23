
{{config(materialized="table")}}

WITH customers as(
    SELECT 
        id as customer_id,
        first_name,
        last_name
        from MANALI_RAW.MANALI_JAFFLE_SHOP.MANALI_CUSTOMERS
),
orders as(
    SELECT 
        id as order_id,
        user_id as customer_id,
        order_date,
        status
        from MANALI_RAW.MANALI_JAFFLE_SHOP.MANALI_ORDERS
),
customer_orders as(
    SELECT 
        customer_id,
        min(order_date) as first_order_date,
        max(order_date) as most_recent_order_date,
        count(order_id) as number_of_orders
        from orders
    GROUP BY 1
),
final as(
    SELECT 
        customers.customer_id,
        customers.first_name,
        customers.last_name,
        customer_orders.first_order_date,
        customer_orders.most_recent_order_date,
        coalesce(customer_orders.number_of_orders,0) as number_of_orders
        from customers
        LEFT JOIN customer_orders USING(customer_id)
)

SELECT * FROM final
