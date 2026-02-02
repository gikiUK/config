module GikiConfig
  class DetermineEnvironment
    include Mandate

    def call
      env = ENV['GIKI_ENV'] || ENV['RAILS_ENV'] || ENV['APP_ENV']
      env = Rails.env.to_s if !env && Object.const_defined?(:Rails) && Rails.respond_to?(:env)

      raise Giki::ConfigError, 'No environment set - set one of GIKI_ENV, RAILS_ENV or APP_ENV' unless env

      Environment.new(env)
    end
  end
end
