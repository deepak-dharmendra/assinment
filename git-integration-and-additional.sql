EMPLOYEE_DB.EMPLOYEE_SCHEMA.SNOWFLAKE_EXTENSIONS
GRANT USAGE ON WAREHOUSE compute_wh TO ROLE admin;
GRANT USAGE ON WAREHOUSE compute_wh TO ROLE read_only;

use ROLE read_only;
SHOW GRANTS TO USER read_only;
GRANT ROLE read_only TO ROLE ACCOUNTADMIN;

SHOW GRANTS TO ROLE admin;
GRANT USAGE ON DATABASE employee_db TO ROLE ADMIN;

GRANT USAGE ON SCHEMA employee_db.employee_schema TO ROLE ADMIN;

GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE employee_db.employee_schema.USER_ADDRESS TO ROLE ADMIN;
GRANT ALL PRIVILEGES ON TABLE employee_db.employee_schema.USER_ADDRESS TO ROLE ADMIN;

update employee_db.employee_schema.user_address set city = 'qqq' where address_id=1;
select * from user_address;

------------------------------------------


create or replace secret github_secret
    type = password
    username = 'deepak-dharmendra'
    password = 'PAT';



CREATE OR REPLACE API INTEGRATION git_api_integration
  API_PROVIDER = git_https_api
  API_ALLOWED_PREFIXES = ('https://github.com/deepak-dharmendra')
  ALLOWED_AUTHENTICATION_SECRETS = (github_secret)
  ENABLED = TRUE;

show api integrations;
show integration;



GRANT CREATE GIT REPOSITORY ON SCHEMA employee_db.employee_schema TO ROLE accountadmin;
-- Grant necessary privileges to the admin role
-- GRANT USAGE ON GIT REPOSITORY snowflake_extensions TO ROLE admin;
-- GRANT CREATE GIT REPOSITORY ON SCHEMA employee_db.employee_schema TO ROLE admin;

CREATE OR REPLACE GIT REPOSITORY snowflake_extensions
  API_INTEGRATION = git_api_integration
  GIT_CREDENTIALS = github_secret
  ORIGIN = 'https://github.com/deepak-dharmendra/assinment.git';

ALTER GIT REPOSITORY snowflake_extensions FETCH;


