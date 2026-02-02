require "test_helper"

class EnvironmentTest < Minitest::Test
  def test_development_environment
    env = GikiConfig::Environment.new('development')

    assert env.development?
    refute env.test?
    refute env.production?
    assert_equal 'development', env.to_s
  end

  def test_test_environment
    env = GikiConfig::Environment.new('test')

    refute env.development?
    assert env.test?
    refute env.production?
    assert_equal 'test', env.to_s
  end

  def test_production_environment
    env = GikiConfig::Environment.new('production')

    refute env.development?
    refute env.test?
    assert env.production?
    assert_equal 'production', env.to_s
  end

  def test_invalid_environment_raises_error
    assert_raises(Giki::ConfigError) do
      GikiConfig::Environment.new('invalid')
    end
  end
end
