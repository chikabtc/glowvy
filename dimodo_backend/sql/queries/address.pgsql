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
WITH addressnew AS (
INSERT INTO address (recipient_name, street, ward_id, telephone, user_id, creater)
    SELECT
        $1,
        $2,
        $3,
        $4,
        $5,
        1
    FROM
        users
    WHERE
        id = $5
    RETURNING
        id)
UPDATE
    users
SET
    address_id = addressnew.id
FROM
    addressnew
WHERE
    users.id = $5;

-- name: getAddrssQuery
WITH account AS (
    SELECT
        address_id
    FROM
        users
    WHERE
        id = $1
)
SELECT
    address.id,
    recipient_name,
    telephone,
    street,
    province.NAME,
    district.NAME,
    ward.NAME
FROM
    address,
    account,
    ward,
    district,
    province
WHERE
    address.ward_id = ward.id
    AND ward.province_id = province.id
    AND ward.district_id = district.id
    AND address.id = account.address_id;

