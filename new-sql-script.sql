-- Drop the database if it exists
DROP DATABASE IF EXISTS demo_db;

-- Create or replace the database
CREATE OR REPLACE DATABASE demo_db;

-- Switch to the newly created database
USE DATABASE demo_db; 

-- Create or replace the schema demo_schema
CREATE OR REPLACE SCHEMA demo_schema; 

-- Create or replace the role developer
CREATE OR REPLACE ROLE developer;

-- Grant usage on the warehouse to the developer role
GRANT USAGE ON WAREHOUSE COMPUTE_WH TO ROLE developer;

-- Grant all privileges on the database to the developer role
GRANT ALL PRIVILEGES ON DATABASE demo_db TO ROLE developer;

-- Grant all privileges on the schema to the developer role
GRANT ALL PRIVILEGES ON SCHEMA demo_schema TO ROLE developer;

-- Grant all privileges on all current tables in the schema to the developer role
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA demo_schema TO ROLE developer;

-- Grant privileges on future tables in the schema to the developer role
GRANT ALL PRIVILEGES ON FUTURE TABLES IN SCHEMA demo_schema TO ROLE developer;

-- Drop the user if it exists
DROP USER IF EXISTS dev_user1;

-- Create the user with a specified password and comment
CREATE USER dev_user1 PASSWORD = 'Password@321' 
    MUST_CHANGE_PASSWORD = FALSE 
    COMMENT = 'dev-user';

-- Assign the developer role to the new user
GRANT ROLE developer TO USER dev_user1;

-- Grant usage on the database to the developer role
GRANT USAGE ON DATABASE demo_db TO ROLE developer;

-- Grant usage on the schema to the developer role
GRANT USAGE ON SCHEMA demo_schema TO ROLE developer;

-- Confirm the grants for dev_user1 (run this as an admin user)
SHOW GRANTS TO USER dev_user1;
GRANT ROLE developer TO USER samcurren400;
USE ROLE developer;

 -- 

 -- Create or replace the role read
CREATE OR REPLACE ROLE select_only;

-- Grant usage on the warehouse to the select_only role
GRANT USAGE ON WAREHOUSE COMPUTE_WH TO ROLE select_only;

-- Grant usage on the demo_db database to the select_only role
GRANT USAGE ON DATABASE demo_db TO ROLE select_only;

-- Grant usage on the demo_schema schema to the select_only role
GRANT USAGE ON SCHEMA demo_schema TO ROLE select_only;

-- Grant select (read) privilege on all current tables in the schema to the select_only role
GRANT SELECT ON ALL TABLES IN SCHEMA demo_schema TO ROLE select_only;

-- Grant select privilege on future tables in the schema to the select_only role
GRANT SELECT ON FUTURE TABLES IN SCHEMA demo_schema TO ROLE select_only;

-- Drop the user if it exists
DROP USER IF EXISTS read_user1;

-- Create the user with a specified password and comment
CREATE USER read_user1 PASSWORD = 'Password@321' 
    MUST_CHANGE_PASSWORD = FALSE 
    COMMENT = 'read-only user';

-- Assign the select_only role to the new user
GRANT ROLE select_only TO USER read_user1;

SHOW GRANTS TO USER read_user1;

GRANT ROLE select_only TO USER samcurren400;
USE ROLE select_only;


DROP TABLE IF EXISTS user;
CREATE TABLE user (
    user_id INT PRIMARY KEY,
    username VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE
);

DROP TABLE IF EXISTS user_address;
CREATE TABLE user_address (
    address_id INT PRIMARY KEY,
    user_id INT,
    street VARCHAR(100) NOT NULL,
    city VARCHAR(50) NOT NULL,
    state VARCHAR(50) NOT NULL,
    country VARCHAR(50) NOT NULL,
    FOREIGN KEY (user_id) REFERENCES user(user_id)
);

DROP TABLE IF EXISTS user_salary;
CREATE TABLE user_salary (
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


CREATE TABLE IF NOT EXISTS validation_errors (
    error_id INT AUTOINCREMENT PRIMARY KEY,
    table_name VARCHAR(50),
    error_message VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE OR REPLACE PROCEDURE validate_user_salary(
    salary_id INT,
    user_id INT,
    salary DECIMAL(10, 2)
)
RETURNS STRING
LANGUAGE SQL
AS
$$
DECLARE
    error_message STRING DEFAULT '';
BEGIN
    -- Check if salary is valid
    IF (salary <= 0) THEN
        -- Define the error message
        error_message := 'Invalid salary value (' || salary || ') for salary ID: ' || salary_id;
        
        -- Insert the error message into the validation_errors table
        INSERT INTO demo_schema.validation_errors (table_name, error_message)
        VALUES ('user_salary', error_message);
        
        -- Return a failure message
        RETURN 'Validation Failed';
    END IF;

    -- If validation passes, return a success message
    RETURN 'Validation Passed';
END;
$$;

CALL demo_schema.validate_user_salary(6, 3, -5000.00);  
CALL demo_schema.validate_user_salary(7, 3, 50000.00);  


