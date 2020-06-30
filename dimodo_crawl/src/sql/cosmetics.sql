-- getCosmeticsWithoutReviews
SELECT
    cosmetics_products.sname,
    cosmetics_products.sid,
    cosmetics_products.volume
FROM
    cosmetics_products
WHERE
    NOT EXISTS (
        SELECT
            1
        FROM
            cosmetics_review
        WHERE
            cosmetics_products.sid = cosmetics_review.product_id);

-- getCosmeticsWithoutPrices
SELECT
    cosmetics_products.sname,
    cosmetics_products.sid,
    cosmetics_products.volume
FROM
    cosmetics_products
WHERE
    sale_price IS NULL;

-- getAllCosmetics
SELECT
    cosmetics_products.sname,
    cosmetics_products.sid,
    cosmetics_products.volume
FROM
    cosmetics_products;

-- updateCosmeticsMetaInfo
UPDATE
    cosmetics_products
SET
    sale_price = :sale_price,
    review_count = :review_count,
    is_naver_shopping = :is_naver_shopping
WHERE
    sid = :sid;

-- createReviews
INSERT INTO cosmetics_review (scontent, product_id, user_name, images, rating, date)
    VALUES (:scontent, :product_id, :user_name, :images, :rating, :date);

-- deleteCosmeticsProduct
DELETE FROM cosmetics_products
WHERE sid = :sid;

