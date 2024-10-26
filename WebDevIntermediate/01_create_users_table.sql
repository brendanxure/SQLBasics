/*
Brendan Obilo
01_create_users_table.sql
02 October 2024
INFT2100
*/

DROP TABLE IF EXISTS users CASCADE;
DROP SEQUENCE IF EXISTS users_id_seq;

CREATE EXTENSION IF NOT EXISTS pgcrypto;
CREATE SEQUENCE users_id_seq START 100900000;

CREATE TABLE users(
    user_id INT PRIMARY KEY DEFAULT nextval('users_id_seq'),
    first_name VARCHAR(255), 
    last_name VARCHAR(255), 
    email VARCHAR(255) UNIQUE NOT NULL, 
    birth_date DATE, 
    created_at DATE DEFAULT CURRENT_DATE,
    last_access TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    password VARCHAR(255)
);

