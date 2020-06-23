--name: FindProductById
SELECT
    product.id,
    product.sprice,
    product.name,
    product.thumbnail
FROM
    product
WHERE
    product.id = $1;

--name: QueryAllCategory
SELECT
    id,
    name,
    image
FROM
    Category;

--name: ProductsByParentCategoryID
WITH matching_product_sids AS (
    SELECT DISTINCT
        sid
    FROM
        product,
        category
    WHERE
        product.category_id = category.id
        AND category.parent_id = $1
)
SELECT
    product.id,
    product.sid,
    product.name,
    product.thumbnail,
    product.sprice,
    product.sale_price,
    product.sale_percent,
    COALESCE(product.purchase_count, 0) AS purchase_count,
    category.name,
    product.category_id,
    json_agg(json_build_object('name', tags.en_name, 'sname', tags.sname, 'id', tags.id, 'type', tags.type))
FROM
    product,
    product_tags,
    matching_product_sids,
    category,
    tags
WHERE
    matching_product_sids.sid = product.sid
    AND category.id = product.category_id
    AND product_tags.product_id = matching_product_sids.sid
    AND tags.id = product_tags.tag_id
GROUP BY
    product.id,
    category.name
ORDER BY
    CASE WHEN $2 = 'sale_price' THEN
        product.sale_price
    END ASC,
    CASE WHEN $2 = '-sale_price' THEN
        product.sale_price
    END DESC,
    CASE WHEN $2 = 'id' THEN
        product.id
    END DESC OFFSET $3
LIMIT $4;

--name: ProductsByCategoryID
WITH matching_product_sids AS (
    SELECT DISTINCT
        sid
    FROM
        product
    WHERE
        product.category_id = $1
)
SELECT
    product.id,
    product.sid,
    product.name,
    product.thumbnail,
    product.sprice,
    product.sale_price,
    product.sale_percent,
    COALESCE(product.purchase_count, 0) AS purchase_count,
    category.name,
    product.category_id,
    json_agg(json_build_object('name', tags.en_name, 'sname', tags.sname, 'id', tags.id, 'type', tags.type))
FROM
    product,
    product_tags,
    matching_product_sids,
    category,
    tags
WHERE
    matching_product_sids.sid = product.sid
    AND category.id = product.category_id
    AND product_tags.product_id = matching_product_sids.sid
    AND tags.id = product_tags.tag_id
GROUP BY
    product.id,
    category.name
ORDER BY
    CASE WHEN $2 = 'sale_price' THEN
        product.sale_price
    END ASC,
    CASE WHEN $2 = '-sale_price' THEN
        product.sale_price
    END DESC,
    CASE WHEN $2 = 'id' THEN
        product.id
    END DESC OFFSET $3
LIMIT $4;

--name: ProductsByTags
WITH matching_product_sids AS (
    SELECT DISTINCT
        product_id
    FROM
        product_tags
    WHERE
        product_tags.tag_id = $1
)
SELECT
    product.id,
    product.sid,
    product.sprice,
    product.sale_price,
    product.sale_percent,
    COALESCE(product.purchase_count, 0) AS purchase_count,
    product.name,
    product.thumbnail,
    product.category_id,
    category.name,
    json_agg(json_build_object('sname', tags.en_name, 'id', tags.id, 'type', tags.type))
FROM
    product,
    product_tags,
    matching_product_sids,
    category,
    tags
WHERE
    matching_product_sids.product_id = product.sid
    AND category.id = product.category_id
    AND product_tags.product_id = matching_product_sids.product_id
    AND tags.id = product_tags.tag_id
GROUP BY
    product.id,
    category.name
ORDER BY
    CASE WHEN $2 = 'sale_price' THEN
        product.sale_price
    END ASC,
    CASE WHEN $2 = '-sale_price' THEN
        product.sale_price
    END DESC,
    CASE WHEN $2 = 'id' THEN
        product.id
    END DESC OFFSET $3
LIMIT $4;

--name: ProductsByShopId
SELECT DISTINCT
    product.id,
    product.sid,
    product.sprice,
    product.sale_price,
    product.sale_percent,
    COALESCE(product.purchase_count, 0) AS purchase_count,
    product.name,
    product.thumbnail
FROM
    product,
    category,
    category_default
WHERE
    product.seller ->> 'id' = $1 OFFSET $2
LIMIT $3;

--name:	CategoryProductsQuery
SELECT
    id,
    sprice,
    name,
    image
FROM
    product
WHERE
    category_id = $1
    AND deleted_at IS NULL OFFSET $2
LIMIT $3;

--name:	CountReviews
SELECT
    COUNT(*)
FROM (
    SELECT
        review.author,
        review.text,
        review.review_id,
        review.product_id,
        review.images
    FROM
        review
    WHERE
        review.product_id = $1 OFFSET $2
    LIMIT $3) subque;

--name: ReviewsByProductID
SELECT
    review.product_id,
    review.review_id,
    review.author,
    review.text,
    COALESCE(review.images, ARRAY[]::text[]) AS images
    --if images don't exist, return empty array
FROM
    review
WHERE
    review.product_id = $1 OFFSET $2
LIMIT $3;

--name:	Options
SELECT
    product.options
FROM
    product
WHERE
    product.sid = $1;

--name: ProductDetailById
WITH item_tags AS (
    SELECT
        json_agg(tags)
    FROM
        product_tags,
        tags
    WHERE
        product_tags.product_id = $1
        AND product_tags.tag_id = tags.id
)
SELECT
    product.Id,
    product.Sid,
    product.name,
    product.sprice,
    product.sale_percent,
    product.sale_price,
    product.description,
    product.thumbnail,
    product.purchase_count,
    product.slider_images,
    product.desc_images,
    item_tags.json_agg,
    product.seller,
    product.size_details,
    product.category_id,
    category.name,
    product.options
FROM
    product,
    item_tags,
    category
WHERE
    product.sid = $1
    AND category.id = product.category_id;

--name:	CheckIfShopExists
SELECT
    seller
FROM
    product
WHERE
    seller ->> 'id' = $1;

--name:	UpdateThumbnailImage
UPDATE
    product
SET
    thumbnail = $2
WHERE
    sid = $1;

--name:	GetAllSidsWithBigThumbnail
SELECT
    sid
FROM
    product
WHERE
    position('_L' IN thumbnail) > 0
ORDER BY
    id DESC;

--name:	GetAllSidsWithBigThumbnail
SELECT DISTINCT
    sid
FROM
    product
WHERE
    sid NOT IN ( SELECT DISTINCT
            product_tags.product_id
        FROM
            product_tags;

--name: GetAllProducts
SELECT
    *
FROM
    product;

--name: GetAllSids
SELECT
    sid
FROM
    product;

--name: AlgolioProductDetailById
WITH item_tags AS (
    SELECT
        json_agg(tags)
    FROM
        product_tags,
        tags
    WHERE
        product_tags.product_id = $1
        AND product_tags.tag_id = tags.id
)
SELECT
    product.Sid,
    product.name,
    product.sprice,
    product.sale_percent,
    product.sale_price,
    product.thumbnail,
    product.purchase_count,
    item_tags.json_agg,
    product.seller,
    category.sname
    -- product.options
FROM
    product,
    item_tags,
    category
WHERE
    product.sid = $1
    AND category.id = product.category_id;

--name: GetSubCategories
SELECT
    category.id,
    category.parent_id,
    category.name,
    category.image
FROM
    category
WHERE
    parent_id = $1;

