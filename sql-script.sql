CREATE DATABASE employee_db;
CREATE SCHEMA employee_db.employee_schema;

CREATE ROLE admin;
CREATE ROLE read_only;

GRANT ALL PRIVILEGES ON ACCOUNT TO ROLE admin;
GRANT USAGE ON DATABASE employee_db TO ROLE read_only;
GRANT USAGE ON SCHEMA employee_db.employee_schema TO ROLE read_only;
GRANT SELECT ON ALL TABLES IN SCHEMA employee_db.employee_schema TO ROLE read_only;

--using created db and schema
USE DATABASE employee_db;
USE SCHEMA employee_db.employee_schema;

-- creating user table
CREATE TABLE user (
    user_id INT PRIMARY KEY,
    username VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE
);

-- creating user_address table
CREATE TABLE user_address (
    address_id INT PRIMARY KEY,
    user_id INT,
    street VARCHAR(100) NOT NULL,
    city VARCHAR(50) NOT NULL,
    state VARCHAR(50) NOT NULL,
    country VARCHAR(50) NOT NULL,
    FOREIGN KEY (user_id) REFERENCES user(user_id)
);

-- creating user_salary table
CREATE TABLE user_salary (
    salary_id INT PRIMARY KEY,
    user_id INT,
    salary DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (user_id) REFERENCES user(user_id)
);

--validation on the tables
ALTER TABLE user ADD CONSTRAINT chk_email CHECK (email LIKE '%_@__%.__%');
ALTER TABLE user_address ADD CONSTRAINT chk_country CHECK (country IN ('USA', 'Canada', 'UK'));
ALTER TABLE user_salary ADD CONSTRAINT chk_salary CHECK (salary > 0);


