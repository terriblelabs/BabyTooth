require 'oauth2'
require 'faraday_stack'
require 'json'

module BabyTooth
  class << self
    attr_accessor :configuration

    def authorize_url
      oauth_client.auth_code.authorize_url :redirect_uri => configuration.redirect_uri
    end

    def configure
      self.configuration ||= Configuration.new
      yield self.configuration
    end

    def get_token(authorization_code)
      oauth_client.auth_code.get_token(authorization_code,
        :redirect_uri => configuration.redirect_uri).token
    end

    def oauth_client
      ::OAuth2::Client.new configuration.client_id, configuration.client_secret,
        :authorize_url => configuration.authorization_url,
        :token_url => configuration.access_token_url
    end
  end

  class Client
    attr_accessor :access_token, :path

    def [](key)
      body[key]
    end

    def body
      @body ||= retrieve_body
    end

    def initialize(access_token, path)
      self.access_token = access_token
      self.path = path
    end

    def resource_class_name
      self.class.name.split('::').last
    end

    def self.exposes_keys(*keys)
      keys.each do |key|
        define_method key do
          body[key.to_s]
        end
      end
    end

    protected

    def retrieve_body
      response = connection.get(path) do |request|
        request.headers['Authorization'] = "Bearer #{access_token}"
        request.headers['Accept'] = "application/vnd.com.runkeeper.#{resource_class_name}+json"
      end

      JSON.parse(response.body)
    end

    def connection
      FaradayStack.build ::BabyTooth.configuration.site
    end
  end

  class User < Client
    exposes_keys 'fitness_activities'

    def initialize(access_token)
      super access_token, '/user'
    end

    def fitness_activity_feed
      @fitness_activity_feed ||= FitnessActivityFeed.new(access_token, fitness_activities)
    end

    def street_team
      @street_team ||= TeamFeed.new(access_token).members
    end

    def profile
      @profile ||= Profile.new(access_token, self['profile'])
    end
  end

  class Profile < Client
    exposes_keys "name",
      "small_picture",
      "large_picture",
      "medium_picture",
      "elite",
      "gender",
      "athlete_type",
      "normal_picture",
      "profile"
  end

  class FitnessActivityFeed < Client
    exposes_keys "items"

    def fitness_activities
      items.map do |item|
        FitnessActivity.new access_token, item['uri']
      end
    end
  end

  class FitnessActivity < Client
  end

  private

  class Configuration
    attr_accessor :client_id, :client_secret, :access_token_url, :authorization_url, :redirect_uri, :site
  end
end
