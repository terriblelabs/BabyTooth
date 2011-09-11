require 'helper'

class TestBabyTooth < Test::Unit::TestCase
  def setup
    BabyTooth.configure do |config|
      config.access_token_url  = "http://runkeeper.com/apps/token"
      config.authorization_url = "http://runkeeper.com/apps/authorize"
      config.client_secret     = "SECRET"
      config.client_id         = "CLIENT_ID"
      config.redirect_uri      = "http://my.app/authorization"
      config.site              = "http://api.runkeeper.com"
    end
  end

  context "configure" do
    should "accept client_id" do
      assert_equal "CLIENT_ID", BabyTooth.configuration.client_id
    end

    should "accept client_secret" do
      assert_equal "SECRET", BabyTooth.configuration.client_secret
    end

    should "accept authorization_url" do
      assert_equal "http://runkeeper.com/apps/authorize", BabyTooth.configuration.authorization_url
    end

    should "accept access_token_url" do
      assert_equal "http://runkeeper.com/apps/token", BabyTooth.configuration.access_token_url
    end

    should "accept redirect_uri" do
      assert_equal "http://my.app/authorization", BabyTooth.configuration.redirect_uri
    end
  end

  context "authorize_url" do
    should "return a URL with the proper parameters including the passed in state" do
      assert_equal "http://runkeeper.com/apps/authorize?response_type=code&client_id=CLIENT_ID&redirect_uri=http%3A%2F%2Fmy.app%2Fauthorization&state=this%20is%20a%20test",
        BabyTooth.authorize_url('this is a test')
    end
  end

  context "get_token" do
    setup do
      VCR.insert_cassette 'oauth/token success', :record => :none
    end

    teardown do
      VCR.eject_cassette
    end

    should "return an access token string" do
      assert_equal "ACCESS_TOKEN", BabyTooth.get_token("TOKEN")
    end
  end

  context "fitness_activity_feed" do
    setup do
      VCR.insert_cassette 'fitness_activities', :record => :none
      @user = BabyTooth::User.new('TEST_TOKEN')
    end

    teardown { VCR.eject_cassette }

    subject { @user.fitness_activity_feed}

    should "be a BabyTooth::FitnessActivityFeed" do
      assert_kind_of BabyTooth::FitnessActivityFeed, subject
    end

    context "fitness_activities" do
      subject { @user.fitness_activity_feed.fitness_activities }

      should "return an array of FitnessActivity objects" do
        assert_kind_of Array, subject

        assert_equal 13, subject.length

        subject.each do |fitness_activity|
          assert_kind_of BabyTooth::FitnessActivity, fitness_activity
        end
      end
    end
  end

  context "street_team" do
    setup do
      VCR.insert_cassette 'street_team', :record => :none
      @user = BabyTooth::User.new('TEST_TOKEN')
    end

    teardown { VCR.eject_cassette }

    subject { @user.street_team }

    should "return an array of members" do
      assert_kind_of Array, subject

      assert_equal 12, subject.size

      teammate = subject.first

      assert_equal 'Ryan Palmer', teammate['name']
      assert_equal 'http://www.runkeeper.com/user/RyanP724', teammate['profile']
      assert_equal '/team/1649313', teammate['url']
    end
  end
end
