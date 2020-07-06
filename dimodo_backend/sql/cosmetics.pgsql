-- name: ProductsByCategoryID
SELECT
    product.id,
    product.sid,
    product.name,
    -- product.eg_name,
    product.thumbnail,
    product.price,
    product.sale_price,
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
    cosmetics_rank.category_id = $1
    AND product.source = 'glowpick'
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
    cosmetics_category.sname
ORDER BY
    CASE WHEN $2 = 'sensitive' THEN
        cosmetics_rank.sensitive_rank
    END ASC,
    CASE WHEN $2 = 'neutral' THEN
        cosmetics_rank.neutral_rank
    END ASC,
    CASE WHEN $2 = 'dry' THEN
        cosmetics_rank.dry_rank
    END ASC,
    CASE WHEN $2 = 'oily' THEN
        cosmetics_rank.oily_rank
    END ASC,
    CASE WHEN $2 = 'all' THEN
        cosmetics_rank.all_rank
    END ASC
LIMIT 30;

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
    cosmetics_review.rating
    -- cosmetics_review.date
FROM
    cosmetics_review
WHERE
    product_id = $1;

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
    id DESC;

--name: GetAllCosmeticsTags
SELECT
    cosmetics_tags.sname,
    cosmetics_tags.id
FROM
    cosmetics_tags
WHERE
    en_name = '';

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
    cosmetics_category.sname
    --name: TranslateCosmetics
    UPDATE
        product
    SET
        -- name = $1
        description = $1
    WHERE
        sid = $2
        AND source = 'glowpick';

