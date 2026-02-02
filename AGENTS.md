# Giki Config Gem - Documentation for Agents

This gem provides centralized configuration and secrets management for the Giki platform, following the same architectural patterns as exercism-config.

## Overview

The giki-config gem manages configuration and secrets for Giki's Rails API and related services. It uses AWS services in production and local YAML files for development/testing.

## Architecture

### Production (AWS-based)
- **Configuration**: Stored in DynamoDB table named `config`
  - Each row has an `id` (config key name) and `value` (config value)
  - Accessed via `Giki.config.*`

- **Secrets**: Stored in AWS Secrets Manager as a JSON blob
  - Secret ID: `config`
  - Contains all sensitive credentials
  - Accessed via `Giki.secrets.*`

### Development/Test (File-based)
- **Configuration**: `settings/local.yml` or `settings/ci.yml`
- **Secrets**: `settings/secrets.yml`
- **Personal overrides**: `~/.config/giki/secrets.yml` (if exists, merges with settings/secrets.yml)

## Available Configuration Keys

### Database (Aurora PostgreSQL)
```ruby
Giki.config.aurora_endpoint      # RDS cluster endpoint
Giki.config.aurora_port          # Database port (usually 5432)
Giki.config.aurora_database_name # Database name
```

### Secrets (Credentials)
```ruby
# Aurora Database
Giki.secrets.aurora_username
Giki.secrets.aurora_password

# SES Email (AWS Simple Email Service)
Giki.secrets.ses_smtp_username
Giki.secrets.ses_smtp_password
Giki.secrets.ses_smtp_address
Giki.secrets.ses_smtp_port

# API Keys
Giki.secrets.google_api_key      # Google Gemini API key
Giki.secrets.elevenlabs_api_key  # ElevenLabs API key
Giki.secrets.heygen_api_key      # HeyGen API key
```

## Helper Methods

### AWS Client Helpers
```ruby
Giki.dynamodb_client  # AWS DynamoDB client (for accessing config table)
Giki.s3_client        # AWS S3 client (for object storage operations)
Giki.ses_client       # AWS SES client (for email operations)
```

These helper methods automatically configure the AWS clients with the correct region and credentials based on the current environment.

## Environment Detection

The gem detects the environment from these sources (in order):
1. `ENV['GIKI_ENV']`
2. `ENV['RAILS_ENV']`
3. `ENV['APP_ENV']`
4. `Rails.env` (if Rails is loaded)

Allowed environments: `development`, `test`, `production`

## Local Development Setup

### Prerequisites
- Docker (for localstack to simulate AWS services)
- Redis (for testing)

### Start LocalStack
```bash
docker run -dp 3042:8080 -p 3040:4566 -p 3041:4566 localstack/localstack
```

### Setup Configuration
```bash
cd giki-config
bundle install
GIKI_ENV=development bundle exec setup_giki_config
```

This will:
1. Create a local DynamoDB table named `config`
2. Load config values from `settings/local.yml` into DynamoDB
3. Create a Secrets Manager secret with values from `settings/secrets.yml`

### Using in Your Application

Add to your Gemfile:
```ruby
gem 'giki-config', path: '../giki-config'  # or from rubygems once published
```

In your code:
```ruby
require 'giki-config'

# Access configuration
db_endpoint = Giki.config.aurora_endpoint

# Access secrets
db_password = Giki.secrets.aurora_password

# Use helper methods
dynamodb = Giki.dynamodb_client
ses = Giki.ses_client
```

## File Structure

```
giki-config/
├── lib/
│   ├── giki-config.rb              # Entry point with Zeitwerk loader
│   ├── giki.rb                     # Main module with .config, .secrets, helpers
│   ├── giki/
│   │   ├── config.rb               # OpenStruct wrapper for config
│   │   └── secrets.rb              # OpenStruct wrapper for secrets
│   └── giki_config/
│       ├── version.rb              # Gem version
│       ├── environment.rb          # Environment object with helpers
│       ├── determine_environment.rb # Detects current environment
│       ├── generate_aws_settings.rb # Generates AWS client settings
│       ├── retrieve_config.rb      # Fetches config from DynamoDB or YAML
│       └── retrieve_secrets.rb     # Fetches secrets from Secrets Manager or YAML
├── settings/
│   ├── local.yml                   # Dev config values
│   ├── ci.yml                      # CI config values
│   └── secrets.yml                 # Dev secrets (not committed in real usage)
├── bin/
│   ├── setup_giki_config           # Setup local DynamoDB and Secrets Manager
│   └── setup_giki_local_aws        # Additional AWS setup utilities
└── test/                           # Test suite
```

## Testing

Run tests locally:
```bash
bundle exec rake test
```

Tests run with:
- LocalStack for AWS services
- Redis for caching tests
- Minitest framework

## Adding New Configuration Keys

1. **Add to settings files**: Update `settings/local.yml`, `settings/ci.yml`, `settings/secrets.yml`
2. **Document in AGENTS.md**: Add to "Available Configuration Keys" section
3. **Update tests**: Add tests for the new key in `test/`
4. **Run setup**: `bundle exec setup_giki_config` to reload local DynamoDB

## Production Deployment

In production:
1. Terraform creates the DynamoDB `config` table
2. Terraform populates config values as items in the table
3. Terraform creates the Secrets Manager secret with sensitive credentials
4. ECS task IAM roles grant read access to the DynamoDB table and Secrets Manager secret
5. Application loads config on boot via `Giki.config` and `Giki.secrets`

## Important Notes

- **Never commit real secrets**: The `settings/secrets.yml` file should contain dummy values for local development
- **Use personal overrides**: For local development with real services, use `~/.config/giki/secrets.yml`
- **AWS Region**: Currently hardcoded to `eu-west-2` in `GenerateAwsSettings`
- **LocalStack endpoint**: Defaults to `http://localhost:3040` for development

## Troubleshooting

### "No environment set" error
Set one of: `GIKI_ENV`, `RAILS_ENV`, or `APP_ENV`

### "Config could not be loaded" error
- Check LocalStack is running: `docker ps`
- Run setup: `bundle exec setup_giki_config`

### Config values are nil
- Verify the key exists in settings YAML files
- Re-run setup to reload DynamoDB: `bundle exec setup_giki_config --force`
