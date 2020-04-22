--name:	CreateCartItem
INSERT INTO cart_item (user_id, option_id, product_id, quantity, option, creater)
    VALUES ($1, $2, $3, $4, $5, $1);

--name:	UpdateCartItem
UPDATE
    cart_item
SET
    quantity = $3
WHERE
    option_id = $2
    AND user_id = $1
RETURNING
    quantity;

--name: RemoveCartItem
DELETE FROM cart_item
WHERE option_id = $2
    AND user_id = $1
RETURNING
    product_id;

--name:	AllCartItems
SELECT
    cart_item.id,
    cart_item.quantity,
    cart_item.option,
    cart_item.option_id,
    product.sid,
    product.name,
    product.thumbnail,
    product.sprice,
    product.sale_price,
    product.sale_percent
FROM
    cart_item,
    product
WHERE
    CAST(cart_item.product_id AS varchar) = product.sid
    AND cart_item.user_id = $1;

--name:	SubItemCartQuery
UPDATE
    cart_item
SET
    quantity = quantity - 1
WHERE
    user_id = $1
    AND cart_id = $2
    AND product_id = $3;

--name:	DeleteItemCartQuery
UPDATE
    cart_item
SET
    deleted_at = extract(epoch FROM now()),
    deleter = $1
WHERE
    id = $2;

--name:	TotalQuantityInCartQuery
SELECT
    quantity
FROM
    cart_item
WHERE
    user_id = $1;

--name:	NewOrder
WITH newOrder AS (
INSERT INTO orders (user_id, is_paid, creater)
        VALUES ($1, FALSE, $1)
    RETURNING
        id, user_id, created_at, is_paid
), moved_rows AS (
    DELETE FROM cart_item
    WHERE cart_item.user_id = $1
    RETURNING
        cart_item.user_id,
        cart_item.option_id,
        cart_item.product_id,
        cart_item.quantity,
        cart_item.OPTION,
        cart_item.creater
),
insertRows AS (
INSERT INTO order_item (user_id, option_id, product_id, quantity, option, creater, order_id)
    SELECT
        moved_rows.user_id,
        moved_rows.option_id,
        moved_rows.product_id,
        moved_rows.quantity,
        moved_rows.OPTION,
        moved_rows.creater,
        newOrder.id
    FROM
        moved_rows,
        newOrder
)
SELECT
    newOrder.id,
    newOrder.user_id,
    newOrder.created_at,
    neworder.is_paid
FROM
    newOrder;

--name:	OrderItemsByID
SELECT
    order_item.id,
    order_item.quantity,
    order_item.option,
    order_item.option_id,
    product.sid,
    product.name,
    product.thumbnail,
    product.sprice,
    product.sale_price,
    product.sale_percent
FROM
    order_item,
    product
WHERE
    CAST(order_item.product_id AS varchar) = product.sid
    AND order_item.order_id = $1;

--name: OrdersByUserID
SELECT
    id,
    is_paid,
    created_at
FROM
    orders
WHERE
    user_id = $1
ORDER BY
    id DESC;

