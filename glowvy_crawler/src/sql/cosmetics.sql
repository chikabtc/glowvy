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
    sale_price IS NULL
    AND source = 'glowpick';

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
    product
WHERE
    source = 'glowpick';

-- getAllCosmeticsWithoutIngredients
SELECT
    product.sname,
    product.sid,
    product.volume
FROM
    product
WHERE
    source = 'glowpick'
    AND NOT EXISTS (
        SELECT
            1
        FROM
            cosmetics_product_ingredient
        WHERE
            product.sid = cosmetics_product_ingredient.product_id);

-- updateCosmeticsMetaInfo
UPDATE
    product
SET
    sale_price = :sale_price
WHERE
    sid = :sid
    AND source = 'glowpick';

-- createReview
INSERT INTO cosmetics_review (scontent, product_id, user_name, images, rating, date, user_age, skin_type)
    VALUES (:scontent, :product_id, :user_name, :images, :rating, :date, :user_age, :skin_type);

-- createIngredient
INSERT INTO cosmetics_ingredient (name_en, purpose_ko, hazard_score)
    VALUES (:name_en, :purpose_ko, :hazard_score);

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
    AND naver_crawlable IS NULL
    AND desc_images IS NULL
ORDER BY
    product.sid ASC;

--updateCosmeticsPhotos
UPDATE
    product
SET
    desc_images = :images
WHERE
    sid = :sid
    AND source = 'glowpick';

--updateCrawlableState
UPDATE
    product
SET
    naver_crawlable = FALSE
WHERE
    sid = :sid
    AND source = 'glowpick';

--addIngredient
WITH new_ingredient AS (
INSERT INTO cosmetics_ingredient (name_en, purpose_ko, hazard_score)
        VALUES (:name_en, :purpose_ko, :hazard_score)
    ON CONFLICT (name_en)
        DO NOTHING
    RETURNING
        *)
    INSERT INTO cosmetics_product_ingredient (product_id, ingredient_id)
    SELECT
        :product_id,
        new_ingredient.id
    FROM
        new_ingredient;

--checkIfIngredientForProductExists
WITH selected_ingredient AS (
    SELECT
        cosmetics_ingredient.name_en,
        cosmetics_ingredient.id
    FROM
        cosmetics_ingredient
    WHERE
        cosmetics_ingredient.name_en = :name_en
)
SELECT
    EXISTS (
        SELECT
            1
        FROM
            cosmetics_product_ingredient,
            selected_ingredient
        WHERE
            cosmetics_product_ingredient.ingredient_id = selected_ingredient.id
            AND cosmetics_product_ingredient.product_id = :product_id
        LIMIT 1);

--addIngredientToProductTags
WITH selected_ingredient AS (
    SELECT
        cosmetics_ingredient.name_en,
        cosmetics_ingredient.id
    FROM
        cosmetics_ingredient
    WHERE
        cosmetics_ingredient.name_en = :name_en)
INSERT INTO cosmetics_product_ingredient (product_id, ingredient_id)
SELECT
    :product_id,
    selected_ingredient.id
FROM
    selected_ingredient;

--getLocallyPopularProduct
SELECT
    sid
FROM
    product
WHERE
    source = 'glowpick'
    AND tag = 'local_popular'
