CREATE TABLE IF NOT EXISTS userss (
    user_id serial PRIMARY KEY,
    username varchar(50) UNIQUE NOT NULL,
    password VARCHAR(50) NOT NULL,
    email varchar(300) UNIQUE NOT NULL
);

