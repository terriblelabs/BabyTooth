require 'helper'

class TestBabyTooth < Test::Unit::TestCase
  context "configure" do
    should "accept client_id" do
      BabyTooth.configure do |config|
        config.client_id = "CLIENT_ID"
      end

      assert_equal "CLIENT_ID", BabyTooth.configuration.client_id
    end

    should "accept client_secret" do
      BabyTooth.configure do |config|
        config.client_secret = "CLIENT_SECRET"
      end

      assert_equal "CLIENT_SECRET", BabyTooth.configuration.client_secret
    end

    should "accept authorization_url" do
      BabyTooth.configure do |config|
        config.authorization_url = "http://runkeeper.com/apps/authorize"
      end

      assert_equal "http://runkeeper.com/apps/authorize", BabyTooth.configuration.authorization_url
    end

    should "accept access_token_url" do
      BabyTooth.configure do |config|
        config.access_token_url = "http://runkeeper.com/apps/token"
      end

      assert_equal "http://runkeeper.com/apps/token", BabyTooth.configuration.access_token_url
    end

    should "accept redirect_uri" do
      BabyTooth.configure do |config|
        config.redirect_uri = "http://my.app/authorization"
      end

      assert_equal "http://my.app/authorization", BabyTooth.configuration.redirect_uri
    end
  end

  context "authorize_url" do
    should "return a URL with the proper parameters" do
      BabyTooth.configure do |config|
        config.access_token_url = "http://runkeeper.com/apps/token"
        config.authorization_url = "http://runkeeper.com/apps/authorize"
        config.client_secret = "SECRET"
        config.client_id = "CLIENT_ID"
        config.redirect_uri = "http://my.app/authorization"
      end

      assert_equal "http://runkeeper.com/apps/authorize?response_type=code&client_id=CLIENT_ID&redirect_uri=http%3A%2F%2Fmy.app%2Fauthorization&state=",
        BabyTooth.authorize_url
    end

    should "return a URL with the proper parameters including the passed in state" do
      BabyTooth.configure do |config|
        config.access_token_url = "http://runkeeper.com/apps/token"
        config.authorization_url = "http://runkeeper.com/apps/authorize"
        config.client_secret = "SECRET"
        config.client_id = "CLIENT_ID"
        config.redirect_uri = "http://my.app/authorization"
      end

      assert_equal "http://runkeeper.com/apps/authorize?response_type=code&client_id=CLIENT_ID&redirect_uri=http%3A%2F%2Fmy.app%2Fauthorization&state=this%20is%20a%20test",
        BabyTooth.authorize_url('this is a test')
    end
  end

  context "get_token" do
    setup do
      VCR.insert_cassette 'oauth/token success', :record => :none
      BabyTooth.configure do |config|
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
      assert_equal "ACCESS_TOKEN", BabyTooth.get_token("TOKEN")
    end
  end
end
