-- name: queryAllProvinces
SELECT
    id,
    NAME,
    INDEX
FROM
    province
ORDER BY
    INDEX, Replace(NAME, 'Đ', 'D') ASC;

-- name: queryListWard
SELECT
    id,
    NAME,
    province_id,
    district_id
FROM
    ward
WHERE
    district_id = $1;

-- name: queryListDistrict
SELECT
    id,
    NAME,
    province_id,
    province_name
FROM
    district
WHERE
    province_id = $1;

-- name: UpdateAddress
UPDATE
    address
SET
    recipient_name = $1,
    street = $2,
    ward_id = $3,
    phone_number = $4,
    is_default = $5
WHERE
    address.id = $6
RETURNING
    user_id;

--name: DeleteAddress
DELETE FROM address
WHERE address.id = $1;

--name: MakeAllAddressesNonDefault
UPDATE
    address
SET
    is_default = FALSE
WHERE
    address.user_id = $1;

--name: CreateAddress
INSERT INTO address (recipient_name, street, ward_id, phone_number, user_id, is_default, creater)
    VALUES ($1, $2, $3, $4, $5, $6, 1)
RETURNING
    id;

-- name: GetAllAddresses
SELECT
    address.id,
    recipient_name,
    phone_number,
    street,
    province.NAME,
    district.NAME,
    ward.NAME,
    address.is_default
FROM
    address,
    ward,
    district,
    province
WHERE
    address.ward_id = ward.id
    AND ward.province_id = province.id
    AND ward.district_id = district.id
    AND address.user_id = $1;

