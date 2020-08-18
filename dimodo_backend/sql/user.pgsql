--name: QuerySignIn
SELECT
    users.Id,
    users.User_name,
    users.Email,
    users.Password,
    users.Full_name,
    users.Display_name,
    users.Phone,
    users.Avatar,
    users.Birthday,
    users.Rid,
    users.Xid,
    users.Sid,
    users.Token,
    users.Session,
    users.signer,
    users.Active
FROM
    users
WHERE (lower(users.User_name) = lower($1)
    OR lower(users.email) = lower($1)
    OR users.phone = $1)
AND users.deleted_at IS NULL;

--name: QuerySignUpUser
WITH systems_insert AS (
INSERT INTO systems (tables, uniques)
        VALUES ('users', $1)
    RETURNING
        id)
    INSERT INTO users (User_name, Email, PASSWORD, Full_name, Display_name, Birthday, Phone, Avatar, Active, Rid, Token, Sid, Xid, signer, Session)
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
        systems_insert.id,
        $12 || systems_insert.id,
        $13,
        $14
    FROM
        systems_insert
    RETURNING
        id,
        sid,
        xid;

--name: CheckEmailQuery
SELECT
    EXISTS (
        SELECT
            1
        FROM
            users
        WHERE
            email = $1
        LIMIT 1);

--name: QuerySignInAuth
SELECT
    users.Id,
    users.User_name,
    users.Email,
    users.Full_name,
    users.Display_name,
    users.Phone,
    users.Avatar,
    users.Birthday,
    users.Rid,
    users.Xid,
    users.Sid,
    users.Token,
    users.Session,
    users.signer,
    users.Active
FROM
    users
WHERE (lower(users.User_name) = lower($1)
    OR lower(users.email) = lower($1)
    OR users.phone = $1)
AND users.deleted_at IS NULL;

--name:	QuerySignUpAuthGoogle
WITH systems_insert AS (
INSERT INTO systems (tables, uniques)
        VALUES ('users', $1)
    RETURNING
        id)
    INSERT INTO users (User_name, Email, Google_id, Full_name, Display_name, Birthday, Phone, Avatar, Active, Rid, Token, Sid, Xid, signer, Session, Google_logged)
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
        systems_insert.id,
        $12 || systems_insert.id,
        $13,
        $14,
        $15
    FROM
        systems_insert
    RETURNING
        id,
        sid,
        xid;

--name:	QueryForgotPassword
WITH pin AS (
    SELECT
        array_to_string(ARRAY (
                SELECT
                    substr('0123456789', ((random() * (10 - 1) + 1)::integer), 1)
            FROM generate_series(1, 6)), '')
),
account AS (
    SELECT
        id,
        full_name
    FROM
        users
    WHERE
        email = $1
        AND deleted_at IS NULL)
INSERT INTO pin_reset_password (id_account, pin, failed, creater) (
    SELECT
        account.id,
        pin.array_to_string,
        0,
        account.id
    FROM
        pin,
        account)
RETURNING
    id,
    id_account,
    pin;

--name:	QueryCheckPin
SELECT
    id
FROM
    pin_reset_password
WHERE
    pin_reset_password.id = $1
    AND pin_reset_password.id_account = $2
    AND pin_reset_password.pin = $3
    AND pin_reset_password.failed < 6;

ChangePasswordQuery UPDATE
    users
SET
    PASSWORD = $2
WHERE
    id = $1;

--name:	QuerySignUpAuthFaceBook
WITH systems_insert AS (
INSERT INTO systems (tables, uniques)
        VALUES ('users', $1)
    RETURNING
        id)
    INSERT INTO users (User_name, Email, Facebook_id, Full_name, Display_name, Birthday, Phone, Avatar, Active, Rid, Token, Sid, Xid, signer, Session, Facebook_logged)
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
        systems_insert.id,
        $12 || systems_insert.id,
        $13,
        $14,
        $15
    FROM
        systems_insert
    RETURNING
        id,
        sid,
        xid;

--name:	signUpWithApple
WITH systems_insert AS (
INSERT INTO systems (tables, uniques)
        VALUES ('users', $1)
    RETURNING
        id)
    INSERT INTO users (User_name, Email, apple_id, Full_name, Display_name, Birthday, Phone, Avatar, Active, Rid, Token, Sid, Xid, signer, Session, apple_logged)
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
        systems_insert.id,
        $12 || systems_insert.id,
        $13,
        $14,
        $15
    FROM
        systems_insert
    RETURNING
        id,
        sid,
        xid;

