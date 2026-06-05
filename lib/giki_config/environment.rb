module GikiConfig
  class Environment
    ALLOWED_ENVS = %w(development test ci production).freeze
    private_constant :ALLOWED_ENVS

    def initialize(raw_env)
      @env = raw_env.to_s

      unless ALLOWED_ENVS.include?(env)
        raise Giki::ConfigError, "environment must be one of #{ALLOWED_ENVS.join(', ')}. Got #{env}."
      end
    end

    def ==(other)
      env == other.to_s
    end

    def eql?(other)
      env == other.to_s
    end

    def hash
      env.hash
    end

    def to_s
      env
    end

    def inspect
      env
    end

    def development?
      env == "development"
    end

    def test?
      env == "test"
    end

    def ci?
      env == "ci"
    end

    def production?
      env == "production"
    end

    private
    attr_reader :env
  end
end
