--name:	GetUnfulfilledOrders
SELECT
    id,
    total_discounts,
    total_fee,
    created_at
FROM
    orders
WHERE
    orders.is_paid = FALSE
    AND orders.is_reminded = FALSE;

--name: setIsRemindedTrue
UPDATE
    orders
SET
    is_reminded = TRUE
WHERE
    id = $1;

