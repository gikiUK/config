# Giki Config

Configuration and secrets management gem for the Giki platform.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'giki-config'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install giki-config

## Usage

```ruby
require 'giki-config'

# Access configuration
Giki.config.aurora_endpoint
Giki.config.aurora_port
Giki.config.aurora_database_name

# Access secrets
Giki.secrets.aurora_username
Giki.secrets.aurora_password
Giki.secrets.ses_smtp_username
Giki.secrets.ses_smtp_password

# Get AWS clients
Giki.dynamodb_client
Giki.ses_client

# Check environment
Giki.env.development?
Giki.env.test?
Giki.env.production?
```

## Local Development

### Prerequisites

- Docker (for LocalStack)
- Ruby 3.2.1+

### Setup

1. Start LocalStack:
```bash
docker run -dp 3042:8080 -p 3040:4566 -p 3041:4566 localstack/localstack
```

2. Install dependencies:
```bash
bundle install
```

3. Setup local AWS services:
```bash
GIKI_ENV=development bundle exec setup_giki_config
```

This will create a local DynamoDB table and Secrets Manager secret with values from the `settings/` directory.

## Configuration

The gem uses different configuration sources based on the environment:

- **Production**: AWS DynamoDB (table: `config`) and AWS Secrets Manager (secret: `config`)
- **Development/Test**: YAML files in `settings/` directory

### Environment Detection

The environment is determined from (in order):
1. `ENV['GIKI_ENV']`
2. `ENV['RAILS_ENV']`
3. `ENV['APP_ENV']`
4. `Rails.env` (if Rails is loaded)

### Available Configuration Keys

#### Database (Aurora PostgreSQL)
- `aurora_endpoint` - RDS cluster endpoint
- `aurora_port` - Database port
- `aurora_database_name` - Database name

#### Secrets
- `aurora_username` - Database username
- `aurora_password` - Database password
- `ses_smtp_username` - SES SMTP username
- `ses_smtp_password` - SES SMTP password
- `ses_smtp_address` - SES SMTP server
- `ses_smtp_port` - SES SMTP port

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/giki-io/config.

## License

See LICENSE file for details.

---

Copyright (c) 2025 Giki Ltd. All rights reserved.
