require 'helper'

class TestHealthGrapher < Test::Unit::TestCase
  context "configure" do
    should "accept client_id" do
      HealthGrapher.configure do |config|
        config.client_id = "CLIENT_ID"
      end

      assert_equal "CLIENT_ID", HealthGrapher.configuration.client_id
    end

    should "accept client_secret" do
      HealthGrapher.configure do |config|
        config.client_secret = "CLIENT_SECRET"
      end

      assert_equal "CLIENT_SECRET", HealthGrapher.configuration.client_secret
    end

    should "accept authorization_url" do
      HealthGrapher.configure do |config|
        config.authorization_url = "http://runkeeper.com/apps/authorize"
      end

      assert_equal "http://runkeeper.com/apps/authorize", HealthGrapher.configuration.authorization_url
    end

    should "accept access_token_url" do
      HealthGrapher.configure do |config|
        config.access_token_url = "http://runkeeper.com/apps/token"
      end

      assert_equal "http://runkeeper.com/apps/token", HealthGrapher.configuration.access_token_url
    end
  end
end
