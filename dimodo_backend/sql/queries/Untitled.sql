WITH item_tags AS (
	SELECT
		ARRAY (
			SELECT
				json_build_object('sname',
					json_agg(tags.sname),
					'id',
					json_agg(tags.id),
					'type',
					json_agg(tags.type))
			FROM
				product_tags,
				tags
			WHERE
				product_tags.product_id = '10366550'
				AND product_tags.tag_id = tags.id)
)
SELECT
	product.Sid, product.name, product.sprice, product.sale_percent, product.sale_price, product.description, product.thumbnail, product.purchase_count, product.slider_images, product.desc_images, product.seller, product.size_details, product.category_id, product.options, item_tags.ARRAY
FROM
	product,
	item_tags
WHERE
	product.sid = '10366550';