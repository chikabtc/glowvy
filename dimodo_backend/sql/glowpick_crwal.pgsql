--name: CreateProduct
INSERT INTO cosmetics_products (sid, sname, volume, price, review_count, average_rating, thumbnail, is_discontinued, brand_id, brand, brand_img, description, category_id)
SELECT
    $1,
    $2,
    $3,
    $4,
    $5,
    $6,
    $7,
    $8,
    $9,
    $10,
    $11,
    $12,
    $13
WHERE
    NOT EXISTS (
        SELECT
            1
        FROM
            cosmetics_products
        WHERE
            sid = $1);

--name: CheckProduct
SELECT
    EXISTS (
        SELECT
            1
        FROM
            cosmetics_products
        WHERE
            sid = $1);

--name:	AddTag
WITH new_tag AS (
INSERT INTO cosmetics_tags (sname)
        VALUES ($1)
    ON CONFLICT (sname)
        DO NOTHING
    RETURNING
        *)
    INSERT INTO cosmetics_product_tags (product_id, tag_id)
    SELECT
        $2,
        new_tag.id
    FROM
        new_tag;

--name: checkIfTagForProductExists
WITH selected_tag AS (
    SELECT
        cosmetics_tags.sname,
        cosmetics_tags.id
    FROM
        cosmetics_tags
    WHERE
        cosmetics_tags.sname = $1
)
SELECT
    EXISTS (
        SELECT
            1
        FROM
            cosmetics_product_tags,
            selected_tag
        WHERE
            cosmetics_product_tags.tag_id = selected_tag.id
            AND cosmetics_product_tags.id = $2
        LIMIT 1);

--name:	AddTagToProductTags
WITH selected_tag AS (
    SELECT
        cosmetics_tags.sname,
        cosmetics_tags.id
    FROM
        cosmetics_tags
    WHERE
        cosmetics_tags.sname = $1)
INSERT INTO cosmetics_product_tags (product_id, tag_id)
SELECT
    $2,
    selected_tag.id
FROM
    selected_tag;

--name: SetCosmeticsAllSKinRank
INSERT INTO cosmetics_rank (all_rank, category_id, product_id)
    VALUES ($1, $2, $3)
ON CONFLICT (product_id, category_id)
    DO UPDATE SET
        all_rank = $1;

--name: SetCosmeticsSensitiveSKinRank
INSERT INTO cosmetics_rank (sensitive_rank, category_id, product_id)
    VALUES ($1, $2, $3)
ON CONFLICT (product_id, category_id)
    DO UPDATE SET
        sensitive_rank = $1;

--name: SetGeneral_DryRank
INSERT INTO cosmetics_rank (dry_rank, category_id, product_id)
    VALUES ($1, $2, $3)
ON CONFLICT (product_id, category_id)
    DO UPDATE SET
        dry_rank = $1;

--name: SetGeneral_OilyRank
INSERT INTO cosmetics_rank (oily_rank, category_id, product_id)
    VALUES ($1, $2, $3)
ON CONFLICT (product_id, category_id)
    DO UPDATE SET
        oily_rank = $1;

--name: SetGeneral_ComplexRank
INSERT INTO cosmetics_rank (complex_rank, category_id, product_id)
    VALUES ($1, $2, $3)
ON CONFLICT (product_id, category_id)
    DO UPDATE SET
        complex_rank = $1;

--name: SetGeneral_NeutralRank
INSERT INTO cosmetics_rank (neutral_rank, category_id, product_id)
    VALUES ($1, $2, $3)
ON CONFLICT (product_id, category_id)
    DO UPDATE SET
        neutral_rank = $1;

