require "test_helper"

class GikiConfigTest < Minitest::Test
  def test_env_defined
    assert Giki.env
  end

  def test_dynamodb_client_returns_client
    client = Giki.dynamodb_client
    assert_instance_of Aws::DynamoDB::Client, client
  end

  def test_s3_client
    s3_client = Giki.s3_client
    assert_equal "eu-west-1", s3_client.config.region
  end

  def test_ses_client
    ses_client = Giki.ses_client
    assert_equal "eu-west-1", ses_client.config.region
  end
end
