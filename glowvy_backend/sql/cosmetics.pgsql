-- name: ProductsByCategoryID
SELECT
    product.id,
    product.sid,
    product.name,
    -- product.eg_name,
    product.thumbnail,
    product.price,
    product.sale_price,
    product.hazard_score,
    product.desc_images,
    product.average_rating,
    product.description,
    product.sdescription,
    product.volume,
    product.review_count,
    cosmetics_category.sname,
    cosmetics_rank.category_id,
    json_agg(DISTINCT jsonb_build_object('name', cosmetics_tags.name, 'sname', cosmetics_tags.sname, 'id', cosmetics_tags.id, 'type', cosmetics_tags.type)),
    json_agg(DISTINCT jsonb_build_object('name_en', cosmetics_ingredient.name_en, 'purposes', jsonb_build_array(cosmetics_ingredient.purpose_vi), 'id', cosmetics_ingredient.id, 'hazard_score', cosmetics_ingredient.hazard_score)),
    cosmetics_brands.name,
    cosmetics_brands.id,
    cosmetics_brands.img,
    cosmetics_rank.all_rank,
    cosmetics_rank.oily_rank,
    cosmetics_rank.dry_rank,
    cosmetics_rank.sensitive_rank
FROM
    product,
    cosmetics_rank,
    cosmetics_product_tags,
    cosmetics_tags,
    cosmetics_category,
    cosmetics_brands,
    cosmetics_ingredient,
    cosmetics_product_ingredient
WHERE
    cosmetics_rank.category_id = $1
    AND product.source = 'glowpick'
    AND cosmetics_rank.product_id = product.sid
    AND cosmetics_category.sid = product.category_id
    AND product.sid = cosmetics_rank.product_id
    AND cosmetics_product_tags.product_id = cosmetics_rank.product_id
    AND cosmetics_tags.id = cosmetics_product_tags.tag_id
    AND cosmetics_product_ingredient.product_id = cosmetics_rank.product_id
    AND cosmetics_ingredient.id = cosmetics_product_ingredient.ingredient_id
    AND cosmetics_brands.sid = product.brand_id
GROUP BY
    product.id,
    cosmetics_rank.category_id,
    cosmetics_rank.sensitive_rank,
    cosmetics_rank.all_rank,
    cosmetics_rank.dry_rank,
    cosmetics_rank.oily_rank,
    cosmetics_rank.neutral_rank,
    cosmetics_brands.sname,
    cosmetics_brands.id,
    cosmetics_brands.img,
    cosmetics_category.sname
ORDER BY
    CASE WHEN $2 = 1 THEN
        cosmetics_rank.sensitive_rank
    END ASC,
    CASE WHEN $2 = 2 THEN
        cosmetics_rank.neutral_rank
    END ASC,
    CASE WHEN $2 = 3 THEN
        cosmetics_rank.dry_rank
    END ASC,
    CASE WHEN $2 = 4 THEN
        cosmetics_rank.oily_rank
    END ASC,
    CASE WHEN $2 = 0 THEN
        cosmetics_rank.all_rank
    END ASC;

--name: AllBrandsSname
SELECT
    sname
FROM
    cosmetics_brands;

--name: AddEnglishBrandName
UPDATE
    cosmetics_brands
SET
    ko_name = $1
WHERE
    sname = $2;

--name: ReviewsByProductID
SELECT
    cosmetics_review.product_id,
    cosmetics_review.user_name,
    cosmetics_review.content,
    cosmetics_review.scontent,
    cosmetics_review.user_age,
    cosmetics_review.skin_type,
    cosmetics_review.skin_type_id,
    cosmetics_review.rating
    -- cosmetics_review.date
FROM
    cosmetics_review
WHERE
    product_id = $1
ORDER BY
    cosmetics_review.id;

--name: GetAllCosmeticsReviews
SELECT
    cosmetics_review.product_id,
    cosmetics_review.user_name,
    cosmetics_review.scontent
FROM
    cosmetics_review
WHERE
    content IS NULL
ORDER BY
    id ASC;

--name: GetAllCosmeticsTags
SELECT
    cosmetics_tags.sname,
    cosmetics_tags.id
FROM
    cosmetics_tags
WHERE
    en_name IS NULL;

--name: GetAllCosmeticsReviewName
SELECT
    cosmetics_review.user_name,
    cosmetics_review.id
FROM
    cosmetics_review
WHERE
    user_en_name IS NULL;

--name: TranslateCosmeticsTag
UPDATE
    cosmetics_tags
SET
    -- user_name = $1,
    en_name = $1
WHERE
    id = $2;

--name: TranslateReviewUserName
UPDATE
    cosmetics_review
SET
    user_en_name = $1
WHERE
    user_name = $2;

--name: TranslateCosmeticsReview
UPDATE
    cosmetics_review
SET
    -- user_name = $1,
    content = $1
WHERE
    cosmetics_review.scontent = $2;

--name: GetAllCosmeticsProducts
SELECT
    product.id,
    product.sid,
    product.name,
    -- product.eg_name,
    product.thumbnail,
    product.price,
    product.sale_price,
    product.hazard_score,
    product.desc_images,
    product.average_rating,
    product.description,
    product.sdescription,
    product.volume,
    product.review_count,
    cosmetics_category.sname,
    cosmetics_rank.category_id,
    json_agg(json_build_object('name', cosmetics_tags.name, 'sname', cosmetics_tags.sname, 'id', cosmetics_tags.id, 'type', cosmetics_tags.type)),
    cosmetics_brands.name,
    cosmetics_brands.id,
    cosmetics_brands.img,
    cosmetics_rank.all_rank,
    cosmetics_rank.oily_rank,
    cosmetics_rank.dry_rank,
    cosmetics_rank.sensitive_rank
FROM
    product,
    cosmetics_rank,
    cosmetics_product_tags,
    cosmetics_tags,
    cosmetics_category,
    cosmetics_brands
WHERE
    product.source = 'glowpick'
    AND cosmetics_rank.product_id = product.sid
    AND cosmetics_category.sid = product.category_id
    AND product.sid = cosmetics_rank.product_id
    AND cosmetics_product_tags.product_id = cosmetics_rank.product_id
    AND cosmetics_tags.id = cosmetics_product_tags.tag_id
    AND cosmetics_brands.sid = product.brand_id
GROUP BY
    product.id,
    cosmetics_rank.category_id,
    cosmetics_rank.sensitive_rank,
    cosmetics_rank.all_rank,
    cosmetics_rank.dry_rank,
    cosmetics_rank.oily_rank,
    cosmetics_rank.neutral_rank,
    cosmetics_brands.sname,
    cosmetics_brands.id,
    cosmetics_brands.img,
    cosmetics_category.sname;

--name: GetAllCosmeticsProductsWithoutName
SELECT
    product.sid,
    product.sname,
    product.sdescription
FROM
    product
WHERE
    product.source = 'glowpick';

--name: TranslateCosmetics
UPDATE
    product
SET
    -- name = $1
    description = $1
WHERE
    sid = $2
    AND source = 'glowpick';

--name: UpdateIngredientScore
UPDATE
    product
SET
    -- name = $1
    ingredient_score = $1
WHERE
    sid = $2
    AND source = 'glowpick';

--name: getLocallyPopularProduct
SELECT
    *
FROM
    product
WHERE
    source = 'glowpick'
    AND tag = 'local_popular';

-- name: ProductsByTag
SELECT
    product.id,
    product.sid,
    product.name,
    -- product.eg_name,
    product.thumbnail,
    product.price,
    product.sale_price,
    product.hazard_score,
    product.desc_images,
    product.average_rating,
    product.description,
    product.sdescription,
    product.volume,
    product.review_count,
    cosmetics_category.sname,
    cosmetics_rank.category_id,
    json_agg(DISTINCT jsonb_build_object('name', cosmetics_tags.name, 'sname', cosmetics_tags.sname, 'id', cosmetics_tags.id, 'type', cosmetics_tags.type)),
    json_agg(DISTINCT jsonb_build_object('name_en', cosmetics_ingredient.name_en, 'purposes', jsonb_build_array(cosmetics_ingredient.purpose_vi), 'id', cosmetics_ingredient.id, 'hazard_score', cosmetics_ingredient.hazard_score)),
    cosmetics_brands.name,
    cosmetics_brands.id,
    cosmetics_brands.img,
    cosmetics_rank.sensitive_rank
FROM
    product,
    cosmetics_rank,
    cosmetics_product_tags,
    cosmetics_tags,
    cosmetics_category,
    cosmetics_brands,
    cosmetics_ingredient,
    cosmetics_product_ingredient
WHERE
    cosmetics_rank.category_id = $1
    AND product.source = 'glowpick'
    AND cosmetics_rank.product_id = product.sid
    AND cosmetics_category.sid = product.category_id
    AND product.sid = cosmetics_rank.product_id
    AND cosmetics_product_tags.product_id = cosmetics_rank.product_id
    AND cosmetics_tags.id = cosmetics_product_tags.tag_id
    AND cosmetics_product_ingredient.product_id = cosmetics_rank.product_id
    AND cosmetics_ingredient.id = cosmetics_product_ingredient.ingredient_id
    AND cosmetics_brands.sid = product.brand_id
GROUP BY
    product.id,
    cosmetics_rank.category_id,
    cosmetics_rank.sensitive_rank,
    cosmetics_rank.all_rank,
    cosmetics_rank.dry_rank,
    cosmetics_rank.oily_rank,
    cosmetics_rank.neutral_rank,
    cosmetics_brands.sname,
    cosmetics_brands.id,
    cosmetics_brands.img,
    cosmetics_category.sname
ORDER BY
    CASE WHEN $2 = 1 THEN
        cosmetics_rank.sensitive_rank
    END ASC,
    CASE WHEN $2 = 2 THEN
        cosmetics_rank.neutral_rank
    END ASC,
    CASE WHEN $2 = 3 THEN
        cosmetics_rank.dry_rank
    END ASC,
    CASE WHEN $2 = 4 THEN
        cosmetics_rank.oily_rank
    END ASC,
    CASE WHEN $2 = 0 THEN
        cosmetics_rank.all_rank
    END ASC
LIMIT 30;

--name: getIngredients
SELECT
    id,
    cosmetics_ingredient.purpose_ko
FROM
    cosmetics_ingredient
WHERE
    length(purpose_ko) > 0;

--name: translateIngredientPurpose
UPDATE
    cosmetics_ingredient
SET
    purpose_vi = $1
WHERE
    id = $2;

--name: IngredientsByProductId
SELECT
    json_agg(DISTINCT jsonb_build_object('name_en', cosmetics_ingredient.name_en, 'purposes', jsonb_build_array(cosmetics_ingredient.purpose_vi), 'id', cosmetics_ingredient.id, 'hazard_score', cosmetics_ingredient.hazard_score))
FROM
    cosmetics_product_ingredient,
    product
WHERE
    cosmetics_ingredient.id = cosmetics_product_ingredient.ingredient_id
    AND cosmetics_product_ingredient.product_id = $1;

--name: ProductDetailById
WITH chosen_category AS (
    SELECT
        cosmetics_category.parent_id
    FROM
        cosmetics_category,
        product
    WHERE
        product.source = 'glowpick'
        AND product.sid = $1
        AND cosmetics_category.sid = product.category_id
)
SELECT
    product.id,
    product.sid,
    product.name,
    -- product.eg_name,
    product.thumbnail,
    product.price,
    product.sale_price,
    product.hazard_score,
    product.desc_images,
    product.average_rating,
    product.description,
    product.sdescription,
    product.volume,
    product.review_count,
    cosmetics_category.sname,
    cosmetics_rank.category_id,
    json_agg(DISTINCT jsonb_build_object('name', cosmetics_tags.name, 'sname', cosmetics_tags.sname, 'id', cosmetics_tags.id, 'type', cosmetics_tags.type)),
    json_agg(DISTINCT jsonb_build_object('name_en', cosmetics_ingredient.name_en, 'purposes', jsonb_build_array(cosmetics_ingredient.purpose_vi), 'id', cosmetics_ingredient.id, 'hazard_score', cosmetics_ingredient.hazard_score)),
    cosmetics_brands.name,
    cosmetics_brands.id,
    cosmetics_brands.img,
    cosmetics_rank.all_rank,
    cosmetics_rank.oily_rank,
    cosmetics_rank.dry_rank,
    cosmetics_rank.sensitive_rank
FROM
    product,
    cosmetics_rank,
    chosen_category,
    cosmetics_product_tags,
    cosmetics_tags,
    cosmetics_category,
    cosmetics_brands,
    cosmetics_ingredient,
    cosmetics_product_ingredient
WHERE
    cosmetics_rank.category_id = chosen_category.parent_id
    AND product.source = 'glowpick'
    AND cosmetics_rank.product_id = $1
    AND cosmetics_category.sid = chosen_category.parent_id
    AND product.sid = $1
    AND cosmetics_product_tags.product_id = $1
    AND cosmetics_tags.id = cosmetics_product_tags.tag_id
    AND cosmetics_product_ingredient.product_id = $1
    AND cosmetics_ingredient.id = cosmetics_product_ingredient.ingredient_id
    AND cosmetics_brands.sid = product.brand_id
GROUP BY
    product.id,
    cosmetics_rank.category_id,
    cosmetics_rank.sensitive_rank,
    cosmetics_rank.all_rank,
    cosmetics_rank.dry_rank,
    cosmetics_rank.oily_rank,
    cosmetics_rank.neutral_rank,
    cosmetics_brands.sname,
    cosmetics_brands.id,
    cosmetics_brands.img,
    cosmetics_category.sname
