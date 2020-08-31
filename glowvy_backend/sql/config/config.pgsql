roDROP TABLE files;


/* systems */
CREATE TABLE files (
    id bigserial PRIMARY KEY,
    name varchar,
    types varchar,
    url varchar,
    size bigint,
    creater bigint NOT NULL,
    updater bigint,
    deleter bigint,
    created_at bigint DEFAULT extract(epoch FROM now()),
    updated_at bigint DEFAULT extract(epoch FROM now()),
    deleted_at bigint
);

DROP TABLE mail_template;


/* mail_template */
CREATE TABLE mail_template (
    id bigserial PRIMARY KEY,
    subject varchar,
    body varchar,
    creater bigint,
    active boolean,
    created_at bigint DEFAULT extract(epoch FROM now()),
    updated_at bigint DEFAULT extract(epoch FROM now()),
    deleted_at bigint
);

DROP TABLE mail_sub;


/* systems */
CREATE TABLE mail_sub (
    id bigserial PRIMARY KEY,
    name varchar,
    subtitles varchar,
    id_mail_template varchar,
    creater bigint,
    active boolean,
    created_at bigint DEFAULT extract(epoch FROM now()),
    updated_at bigint DEFAULT extract(epoch FROM now()),
    deleted_at bigint
);

DROP TABLE mail_smtp;


/* smtp */
CREATE TABLE mail_smtp (
    id bigserial PRIMARY KEY,
    address varchar NOT NULL,
    host varchar NOT NULL,
    port varchar NOT NULL,
    password varchar NOT NULL,
    user_name varchar,
    active boolean,
    created_at bigint DEFAULT extract(epoch FROM now()),
    updated_at bigint DEFAULT extract(epoch FROM now()),
    deleted_at bigint
);

INSERT INTO mail_smtp (id, address, host, port, PASSWORD)
    VALUES (1, 'no-reply@webtamky.com', 'smtp.zoho.com', '587', 'oBX2txtUYgM@');

INSERT INTO mail_sub (id, name, subtitles)
    VALUES (1, 'forgot password', 'abc');

DROP TABLE users;

CREATE TABLE users (
    id bigserial PRIMARY KEY,
    full_name varchar,
    full_name_en varchar,
    display_name varchar CHECK (display_name <> ''),
    user_name varchar UNIQUE NOT NULL CHECK (user_name ~ '^[a-z._]+[0-9]+$|^[a-z]+$|^[a-z._]+[a-z]$^[^\ ]+$'),
    email varchar UNIQUE CHECK (email ~* '^[0-9]*[A-Za-z][A-Za-z0-9._%-]+@[A-Za-z0-9.-]+[.][A-Za-z]+$'),
    email_verified boolean,
    phone varchar UNIQUE,
    password varchar,
    birthday timestamptz,
    gender int,
    avatar varchar,
    rid bigint CHECK (rid > 0),
    sid bigint NOT NULL UNIQUE,
    active boolean,
    token varchar NOT NULL,
    session varchar NOT NULL,
    address_id bigint,
    cart_id bigint,
    Facebook_id varchar,
    Facebook_logged boolean,
    Google_id varchar,
    Google_logged boolean,
    oid varchar,
    xid varchar NOT NULL,
    signer varchar NOT NULL,
    creater bigint,
    updater bigint,
    deleter bigint,
    created_at bigint DEFAULT extract(epoch FROM now()),
    updated_at bigint DEFAULT extract(epoch FROM now()),
    deleted_at bigint
);

DROP TABLE roles;

CREATE TABLE roles (
    id bigserial PRIMARY KEY,
    name varchar UNIQUE NOT NULL CHECK (name <> ''),
    active boolean DEFAULT TRUE,
    created_at bigint DEFAULT extract(epoch FROM now()),
    updated_at bigint DEFAULT extract(epoch FROM now()),
    deleted_at bigint
);

DROP TABLE systems;

CREATE TABLE systems (
    id bigserial PRIMARY KEY,
    tables varchar NOT NULL,
    uniques varchar UNIQUE,
    created_at bigint DEFAULT extract(epoch FROM now()),
    updated_at bigint DEFAULT extract(epoch FROM now()),
    deleted_at bigint
);

DROP TABLE subject;

CREATE TABLE subject (
    /* Email */
    id bigserial PRIMARY KEY,
    email varchar UNIQUE CHECK (email ~* '^[0-9]*[A-Za-z][A-Za-z0-9._%-]+@[A-Za-z0-9.-]+[.][A-Za-z]+$'),
    email_verified boolean
);

DROP TABLE pin_reset_password;

CREATE TABLE pin_reset_password (
    id bigserial PRIMARY KEY,
    id_account bigint,
    pin varchar NOT NULL,
    failed int,
    creater bigint NOT NULL,
    created_at bigint DEFAULT extract(epoch FROM now())
);

DROP TABLE category_default;

CREATE TABLE category_default (
    id bigserial PRIMARY KEY,
    name varchar,
    thumbnail varchar,
    creater bigint NOT NULL,
    updater bigint,
    deleter bigint,
    created_at bigint DEFAULT extract(epoch FROM now()),
    updated_at bigint DEFAULT extract(epoch FROM now()),
    deleted_at bigint
);

DROP TABLE dategory_handle;

CREATE TABLE dategory_handle (
    id bigserial PRIMARY KEY,
    name varchar,
    image varchar,
    creater bigint NOT NULL,
    updater bigint,
    deleter bigint,
    created_at bigint DEFAULT extract(epoch FROM now()),
    updated_at bigint DEFAULT extract(epoch FROM now()),
    deleted_at bigint
);

DROP TABLE category;

CREATE TABLE category (
    id bigserial PRIMARY KEY,
    name varchar,
    image varchar,
    category_default_id bigint,
    category_handle_id bigint,
    creater bigint NOT NULL,
    updater bigint,
    deleter bigint,
    created_at bigint DEFAULT extract(epoch FROM now()),
    updated_at bigint DEFAULT extract(epoch FROM now()),
    deleted_at bigint
);

DROP TABLE product;

CREATE TABLE product (
    id bigserial PRIMARY KEY,
    name varchar,
    describe varchar,
    price bigint,
    sale_price bigint,
    purchase_count bigint,
    sale_percent bigint,
    category_id bigint,
    barcode varchar,
    thumbnail varchar,
    sid varchar,
    price bigint,
    sname varchar,
    surl varchar,
    creater bigint NOT NULL,
    updater bigint,
    deleter bigint,
    created_at bigint DEFAULT extract(epoch FROM now()),
    updated_at bigint DEFAULT extract(epoch FROM now()),
    deleted_at bigint
);

DROP TABLE seller CREATE TABLE seller (
    id bigserial PRIMARY KEY, name varchar, describe varchar, phone varchar, address varchar, creater bigint NOT NULL, updater bigint, deleter bigint, created_at bigint DEFAULT extract(epoch FROM now()), updated_at bigint DEFAULT extract(epoch FROM now()), deleted_at bigint
);

DROP TABLE brandi_seller;

CREATE TABLE brandi_seller (
    id bigserial PRIMARY KEY,
    kakao_talk_id varchar,
    kakao_yellow_id varchar,
    email varchar,
    seller varchar,
    phone varchar,
    name varchar,
    name_en varchar,
    address varchar,
    bookmark varchar,
    business_name varchar,
    business_code varchar,
    representative_name varchar,
    mail_order_business_code varchar
);

DROP TABLE province;

CREATE TABLE province (
    id bigserial PRIMARY KEY,
    name varchar,
    index varchar,
    creater bigint NOT NULL,
    updater bigint,
    deleter bigint,
    created_at bigint DEFAULT extract(epoch FROM now()),
    updated_at bigint DEFAULT extract(epoch FROM now()),
    deleted_at bigint
);

DROP TABLE district;

CREATE TABLE district (
    id bigserial PRIMARY KEY,
    name varchar,
    province_id bigint,
    province_name varchar,
    creater bigint NOT NULL,
    updater bigint,
    deleter bigint,
    created_at bigint DEFAULT extract(epoch FROM now()),
    updated_at bigint DEFAULT extract(epoch FROM now()),
    deleted_at bigint
);

DROP TABLE ward;

CREATE TABLE ward (
    id bigserial PRIMARY KEY,
    name varchar,
    province_id bigint,
    district_id bigint,
    creater bigint NOT NULL,
    updater bigint,
    deleter bigint,
    created_at bigint DEFAULT extract(epoch FROM now()),
    updated_at bigint DEFAULT extract(epoch FROM now()),
    deleted_at bigint
);

DROP TABLE address;

CREATE TABLE address (
    id bigserial PRIMARY KEY,
    recipient_name varchar,
    street varchar,
    ward_id bigint,
    telephone varchar,
    is_default boolean,
    user_id bigint,
    creater bigint NOT NULL,
    updater bigint,
    deleter bigint,
    created_at bigint DEFAULT extract(epoch FROM now()),
    updated_at bigint DEFAULT extract(epoch FROM now()),
    deleted_at bigint
);

DROP TABLE cart;

CREATE TABLE cart (
    id bigserial PRIMARY KEY,
    user_id bigint,
    creater bigint NOT NULL,
    updater bigint,
    deleter bigint,
    created_at bigint DEFAULT extract(epoch FROM now()),
    updated_at bigint DEFAULT extract(epoch FROM now()),
    deleted_at bigint
);

DROP TABLE cart_item;

CREATE TABLE cart_item (
    id bigserial PRIMARY KEY,
    cart_id bigint,
    product_id bigint,
    user_id bigint,
    quantity bigint,
    creater bigint NOT NULL,
    updater bigint,
    deleter bigint,
    created_at bigint DEFAULT extract(epoch FROM now()),
    updated_at bigint DEFAULT extract(epoch FROM now()),
    deleted_at bigint
);

DROP TABLE orders;

CREATE TABLE orders (
    id bigserial PRIMARY KEY,
    user_id bigint,
    grand_total bigint,
    creater bigint NOT NULL,
    updater bigint,
    deleter bigint,
    created_at bigint DEFAULT extract(epoch FROM now()),
    updated_at bigint DEFAULT extract(epoch FROM now()),
    deleted_at bigint
);

DROP TABLE order_detail;

CREATE TABLE order_detail (
    id bigserial PRIMARY KEY,
    order_id bigint,
    product_id bigint,
    quatity bigint,
    creater bigint NOT NULL,
    updater bigint,
    deleter bigint,
    created_at bigint DEFAULT extract(epoch FROM now()),
    updated_at bigint DEFAULT extract(epoch FROM now()),
    deleted_at bigint
);

DROP TABLE order_status;

CREATE TABLE order_status (
    id bigserial PRIMARY KEY,
    label varchar,
    status varchar,
    creater bigint NOT NULL,
    updater bigint,
    deleter bigint,
    created_at bigint DEFAULT extract(epoch FROM now()),
    updated_at bigint DEFAULT extract(epoch FROM now()),
    deleted_at bigint
);

DROP TABLE payment_method;

CREATE TABLE payment_method (
    id bigserial PRIMARY KEY,
    name varchar,
    title varchar,
    text varchar,
    creater bigint NOT NULL,
    updater bigint,
    deleter bigint,
    created_at bigint DEFAULT extract(epoch FROM now()),
    updated_at bigint DEFAULT extract(epoch FROM now()),
    deleted_at bigint
);

DROP TABLE payment_method;

CREATE TABLE shipping_method (
    id bigserial PRIMARY KEY,
    name varchar,
    /*standard , fast*/
    title varchar,
    /*tiêu chuẩn  , nhanh */
    expected varchar,
    creater bigint NOT NULL,
    updater bigint,
    deleter bigint,
    created_at bigint DEFAULT extract(epoch FROM now()),
    updated_at bigint DEFAULT extract(epoch FROM now()),
    deleted_at bigint
);

