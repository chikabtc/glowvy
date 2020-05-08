--name: sqlCreateProducts
INSERT INTO product (sid, sprice, sale_price, sale_percent, purchase_count, name, category_id, thumbnail, tags, creater)
SELECT
   CAST($1 AS varchar),
   $2,
   $3,
   $4,
   $5,
   $6,
   $7,
   $8,
   $9,
   1
WHERE
   NOT EXISTS (
      SELECT
         1
      FROM
         product
      WHERE
         sid = $1);

--name: createBrandiSeller
INSERT INTO brandi_seller (kakao_talk_id, kakao_yellow_id, email, seller, phone, name, name_en, address, bookmark, business_name, business_code, representative_name, mail_order_business_code)
SELECT
   $1,
   $2,
   $3,
   CAST($4 AS varchar),
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
         brandi_seller
      WHERE
         seller = $4);

sprice,
sale_price,
sale_percent,
thumbnail
--name: AddProductDetailsById
UPDATE
   product
SET
   sid = CAST($1 AS varchar),
   sprice = $2,
   sale_price = $3,
   sale_percent = $4,
   purchase_count = $5,
   description = $6,
   slider_images = $7,
   desc_images = $8,
   options = $9,
   seller = $10,
   size_details = $11
WHERE
   sid = CAST($1 AS varchar);

--name: CreateReviews
INSERT INTO review (product_id, review_id, author, text, images)
   VALUES ($1, $2, $3, $4, $5);

--name: AddProductsByShopId
INSERT INTO product (sid, name, price, sale_percent, sale_price, thumbnail, creater)
   VALUES ($1, $2, $3, $4, $5, $6, 1);

--name: CreateProduct
INSERT INTO product (sid, sname, name, sprice, sale_price, sale_percent, purchase_count, thumbnail, description, slider_images, desc_images, options, soptions, seller, size_details, category_id, tags, creater)
SELECT
   CAST($1 AS varchar),
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
   $13,
   $14,
   $15,
   $16,
   $17,
   1
WHERE
   NOT EXISTS (
      SELECT
         1
      FROM
         product
      WHERE
         sid = $1);

--name: CheckProduct
SELECT
   EXISTS (
      SELECT
         1
      FROM
         product
      WHERE
         sid = $1);

--name:	GetSidsOfAllProducts
SELECT
   sid
FROM
   product;

--name:	UpdateProduct
UPDATE
   product
SET
   sprice = $1,
   sale_price = $2,
   sale_percent = $3,
   category_id = $4,
   options = $5
WHERE
   sid = $6;

