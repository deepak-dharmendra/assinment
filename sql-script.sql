CREATE DATABASE employee_db;
CREATE SCHEMA employee_db.employee_schema;

CREATE ROLE admin;
CREATE ROLE read_only;

SELECT CURRENT_ROLE();


GRANT ALL PRIVILEGES ON ACCOUNT TO ROLE admin;
GRANT USAGE ON DATABASE employee_db TO ROLE read_only;
GRANT USAGE ON SCHEMA employee_db.employee_schema TO ROLE read_only;
GRANT SELECT ON ALL TABLES IN SCHEMA employee_db.employee_schema TO ROLE read_only;

--using created db and schema
USE DATABASE employee_db;
USE SCHEMA employee_db.employee_schema;

-- creating user table
CREATE TABLE IF NOT EXISTS user (
    user_id INT PRIMARY KEY,
    username VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE
);

-- creating user_address table
CREATE TABLE IF NOT EXISTS user_address (
    address_id INT PRIMARY KEY,
    user_id INT,
    street VARCHAR(100) NOT NULL,
    city VARCHAR(50) NOT NULL,
    state VARCHAR(50) NOT NULL,
    country VARCHAR(50) NOT NULL,
    FOREIGN KEY (user_id) REFERENCES user(user_id)
);

-- creating user_salary table
CREATE TABLE IF NOT EXISTS user_salary (
    salary_id INT PRIMARY KEY,
    user_id INT,
    salary DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (user_id) REFERENCES user(user_id)
);



-- Inserting sample data into the user table
INSERT INTO user (user_id, username, email) VALUES 
(1, 'john_doe', 'john.doe@example.com'),
(2, 'jane_smith', 'jane.smith@example.com'),
(3, 'alex_johnson', 'alex.johnson@example.com'),
(4, 'maria_garcia', 'maria.garcia@example.com'),
(5, 'peter_brown', 'peter.brown@example.com');

INSERT INTO user_address (address_id, user_id, street, city, state, country) VALUES 
(1, 1, '123 Main St', 'Springfield', 'IL', 'USA'),
(2, 2, '456 Oak St', 'Metropolis', 'NY', 'USA'),
(3, 3, '789 Pine St', 'Gotham', 'NJ', 'USA'),
(4, 4, '321 Maple Ave', 'Star City', 'CA', 'USA'),
(5, 5, '654 Cedar Rd', 'Smallville', 'KS', 'USA');

-- Inserting sample data into the user_salary table
INSERT INTO user_salary (salary_id, user_id, salary) VALUES 
(1, 1, 60000.00),
(2, 2, 70000.00),
(3, 3, 80000.00),
(4, 4, 50000.00),
(5, 5, 90000.00);


select * from user_salary;





--validation on the tables
CREATE TABLE IF NOT EXISTS validation_errors (
    error_id INT AUTOINCREMENT PRIMARY KEY,
    table_name VARCHAR(50),
    error_message VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- Validation for User Table
CREATE OR REPLACE PROCEDURE validate_user(
    user_id INT,
    username VARCHAR,
    email VARCHAR
)
RETURNS STRING
LANGUAGE SQL
AS
$$
BEGIN
    -- Check email format
    IF NOT (email LIKE '%_@__%.__%') THEN
        INSERT INTO validation_notifications (message) 
        VALUES ('Invalid email format for user: ' || username);
        RETURN 'Validation Failed';
    END IF;

    RETURN 'Validation Passed';
END;
$$;

-- Validation for User Address Table
CREATE OR REPLACE PROCEDURE validate_user_address(
    address_id INT,
    user_id INT,
    street VARCHAR,
    city VARCHAR,
    state VARCHAR,
    country VARCHAR
)
RETURNS STRING
LANGUAGE SQL
AS
$$
BEGIN
    -- Check valid country
    IF NOT (country IN ('USA', 'Canada', 'UK')) THEN
        INSERT INTO validation_notifications (message) 
        VALUES ('Invalid country for address ID: ' || address_id);
        RETURN 'Validation Failed';
    END IF;

    RETURN 'Validation Passed';
END;
$$;

-- Validation for User Salary Table
CREATE OR REPLACE PROCEDURE validate_user_salary(
    salary_id INT,
    user_id INT,
    salary DECIMAL(10, 2)
)
RETURNS STRING
LANGUAGE SQL
AS
$$
BEGIN
    -- Check salary greater than zero
    IF (salary <= 0) THEN
        INSERT INTO validation_notifications (message) 
        VALUES ('Invalid salary for salary ID: ' || salary_id);
        RETURN 'Validation Failed';
    END IF;

    RETURN 'Validation Passed';
END;
$$;






ALTER TABLE user ADD CONSTRAINT chk_email CHECK (email LIKE '%_@__%.__%');
ALTER TABLE user_address ADD CONSTRAINT chk_country CHECK (country IN ('USA', 'Canada', 'UK'));
ALTER TABLE user_salary ADD CONSTRAINT chk_salary CHECK (salary > 0);


