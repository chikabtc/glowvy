-- name: ProductsByCategoryID
SELECT
    cosmetics_products.id,
    cosmetics_products.sid,
    cosmetics_products.sname,
    -- cosmetics_products.eg_name,
    cosmetics_products.thumbnail,
    cosmetics_products.price,
    cosmetics_products.sale_price,
    cosmetics_products.description,
    cosmetics_products.sdescription,
    cosmetics_products.volume,
    cosmetics_products.review_count,
    cosmetics_category.sname,
    cosmetics_rank.category_id,
    json_agg(json_build_object('name', cosmetics_tags.en_name, 'sname', cosmetics_tags.sname, 'id', cosmetics_tags.id, 'type', cosmetics_tags.type)),
    cosmetics_brands.sname,
    cosmetics_brands.id,
    cosmetics_brands.img
FROM
    cosmetics_products,
    cosmetics_rank,
    cosmetics_product_tags,
    cosmetics_tags,
    cosmetics_category,
    cosmetics_brands
WHERE
    cosmetics_rank.category_id = $1
    AND cosmetics_category.sid = cosmetics_products.category_id
    AND cosmetics_products.sid = cosmetics_rank.product_id
    AND cosmetics_product_tags.product_id = cosmetics_rank.product_id
    AND cosmetics_tags.id = cosmetics_product_tags.tag_id
    AND cosmetics_brands.sid = cosmetics_products.brand_id
GROUP BY
    cosmetics_products.id,
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
LIMIT 15;

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

