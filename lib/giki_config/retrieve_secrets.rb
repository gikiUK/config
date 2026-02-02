module GikiConfig
  class RetrieveSecrets
    include Mandate

    def call
      return use_non_production_settings unless Giki.env.production?

      retrieve_from_aws
    end

    private
    def use_non_production_settings
      require 'erb'
      require 'yaml'

      secrets_file = File.expand_path('../../settings/secrets.yml', __dir__)
      secrets = YAML.safe_load(ERB.new(File.read(secrets_file)).result)

      personal_secrets_file = "#{Dir.home}/.config/giki/secrets.yml"
      if File.exist?(personal_secrets_file)
        personal_secrets = YAML.safe_load(ERB.new(File.read(personal_secrets_file)).result)
        Giki::Secrets.new(secrets.merge(personal_secrets))
      else
        Giki::Secrets.new(secrets)
      end
    end

    def retrieve_from_aws
      client = Aws::SecretsManager::Client.new(GenerateAwsSettings.())
      json = client.get_secret_value(secret_id: "config").secret_string
      Giki::Secrets.new(JSON.parse(json))
    rescue StandardError => e
      raise Giki::ConfigError, "Giki's secrets could not be loaded: #{e.message}"
    end
  end
end
