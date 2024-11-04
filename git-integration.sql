CREATE OR REPLACE SECRET github_secret
    TYPE = 'PASSWORD'
    USERNAME = 'deepak-dharmendra'
    PASSWORD = 'PAT';

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
