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
    product.category_id,
    product.thumbnail,
    product.price,
    product.sale_price,
    product.sale_percent
FROM
    cart_item,
    product
WHERE
    cart_item.product_id = product.sid
    AND cart_item.user_id = $1;

--name:	AvailableCoupons
SELECT
    coupon.id,
    coupon.user_id,
    coupon.code,
    coupon.description,
    coupon.discount_type,
    coupon.discount_amount,
    coupon.discount_percentage,
    coupon.usage_limit,
    coupon.usage_count,
    coupon.minimum_amount,
    coupon.maximum_amount,
    coupon.date_created,
    coupon.date_expires
FROM
    coupon
WHERE
    user_id = $1
    AND usage_count < usage_limit;

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

--name:	CreateOrder
WITH newOrder AS (
INSERT INTO orders (user_id, address_id, total_shipping, total_fee, total_discounts, creater, ward_id, phone_number, street)
    SELECT
        $1,
        $2,
        $3,
        $4,
        $5,
        $1,
        address.ward_id,
        address.phone_number,
        address.street
    FROM
        address
    WHERE
        address.id = $2
    RETURNING
        id
),
moved_rows AS (
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
    id
FROM
    newOrder;

--name: UpdateCouponUsageCount
UPDATE
    coupon
SET
    usage_count = usage_count + 1
WHERE
    id = $1
    AND user_id = $2;

--name:	OrderItemsByID
SELECT
    order_item.id,
    order_item.quantity,
    order_item.option,
    order_item.option_id,
    product.sid,
    product.category_id,
    product.name,
    product.thumbnail,
    product.price,
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
    user_id,
    is_paid,
    address_id,
    total_shipping,
    total_fee,
    total_discounts,
    created_at
FROM
    orders
WHERE
    user_id = $1
ORDER BY
    id DESC;

--name: GetUserById
SELECT
    users.Id,
    users.User_name,
    users.Email,
    users.Password,
    users.Full_name,
    users.Display_name,
    users.Phone,
    users.Avatar,
    users.Birthday,
    users.Rid,
    users.Xid,
    users.Sid,
    users.Token,
    users.Session,
    users.signer,
    users.Active
FROM
    users
WHERE
    user_id = $1;

--name: OrderDetailByOrderID
SELECT
    id,
    user_id,
    address_id,
    total_shipping,
    total_fee,
    is_paid
FROM
    orders
WHERE
    id = $1;

-- name: getAddrssQuery
WITH account AS (
    SELECT
        address_id
    FROM
        users
    WHERE
        id = $1
)
SELECT
    address.id,
    recipient_name,
    telephone,
    street,
    province.NAME,
    district.NAME,
    ward.NAME
FROM
    address,
    account,
    ward,
    district,
    province
WHERE
    address.ward_id = ward.id
    AND ward.province_id = province.id
    AND ward.district_id = district.id
    AND address.id = account.address_id;

