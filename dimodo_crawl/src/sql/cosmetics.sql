-- getCosmeticsWithoutReviews
SELECT
    product.sname,
    product.sid,
    product.volume
FROM
    product
WHERE
    product.source = 'glowpick'
    AND NOT EXISTS (
        SELECT
            1
        FROM
            cosmetics_review
        WHERE
            product.sid = cosmetics_review.product_id);

-- getCosmeticsWithoutSalesPrice
SELECT
    product.sname,
    product.sid,
    product.volume
FROM
    product
WHERE
    sale_price IS NULL;

-- getCosmeticsWithoutPrices
SELECT
    product.sname,
    product.sid,
    product.volume
FROM
    product
WHERE
    sale_price IS NULL;

-- getAllCosmetics
SELECT
    product.sname,
    product.sid,
    product.volume
FROM
    product;

-- updateCosmeticsMetaInfo
UPDATE
    product
SET
    sale_price = :sale_price
WHERE
    sid = :sid
    AND source = 'glowpick';

-- createReviews
INSERT INTO cosmetics_review (scontent, product_id, user_name, images, rating, date, user_age, skin_type)
    VALUES (:scontent, :product_id, :user_name, :images, :rating, :date, :user_age, :skin_type);

-- deleteCosmeticsProduct
DELETE FROM product
WHERE sid = :sid
    AND source = 'glowpick';

-- getCosmeticsWithoutImages
SELECT
    product.sname,
    product.sid,
    product.volume
FROM
    product
WHERE
    product.source = 'glowpick'
    AND desc_images IS NULL;

--updateCosmeticsPhotos
UPDATE
    product
SET
    desc_images = desc_images || :images
WHERE
    sid = :sid
    AND source = 'glowpick'
