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

    should "accept redirect_uri" do
      HealthGrapher.configure do |config|
        config.redirect_uri = "http://my.app/authorization"
      end

      assert_equal "http://my.app/authorization", HealthGrapher.configuration.redirect_uri
    end
  end

  context "authorize_url" do
    should "return a URL with the proper parameters" do
      HealthGrapher.configure do |config|
        config.access_token_url = "http://runkeeper.com/apps/token"
        config.authorization_url = "http://runkeeper.com/apps/authorize"
        config.client_secret = "SECRET"
        config.client_id = "CLIENT_ID"
        config.redirect_uri = "http://my.app/authorization"
      end

      assert_equal "http://runkeeper.com/apps/authorize?response_type=code&client_id=CLIENT_ID&redirect_uri=http%3A%2F%2Fmy.app%2Fauthorization",
        HealthGrapher.authorize_url
    end
  end

  context "get_token" do
    setup do
      VCR.insert_cassette 'oauth/token success', :record => :none
      HealthGrapher.configure do |config|
        config.access_token_url = "http://runkeeper.com/apps/token"
        config.authorization_url = "http://runkeeper.com/apps/authorize"
        config.client_secret = "SECRET"
        config.client_id = "ID"
        config.redirect_uri = "http://steps.dev/authorization"
      end
    end

    teardown do
      VCR.eject_cassette
    end

    should "return an access token string" do
      assert_equal "ACCESS_TOKEN", HealthGrapher.get_token("TOKEN")
    end
  end
end
