module GikiConfig
  class GenerateAwsSettings
    include Mandate

    def call
      {
        region: 'eu-west-1',
        endpoint:,
        access_key_id: aws_access_key_id,
        secret_access_key: aws_secret_access_key
      }.select { |_k, v| v }
    end

    memoize
    def aws_access_key_id
      Giki.env.production? ? nil : 'FAKE'
    end

    memoize
    def aws_secret_access_key
      Giki.env.production? ? nil : 'FAKE'
    end

    memoize
    def endpoint
      return nil if Giki.env.production?
      return "http://127.0.0.1:#{ENV['AWS_PORT']}" if Giki.env.test? && ENV['GIKI_CI']

      "http://localhost:3065"
    end
  end
end
