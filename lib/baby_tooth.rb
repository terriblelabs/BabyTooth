require 'oauth2'
require 'faraday_stack'
require 'json'
require 'baby_tooth/client'
require 'baby_tooth/user'
require 'baby_tooth/profile'
require 'baby_tooth/fitness_activity_feed'
require 'baby_tooth/fitness_activity'

module BabyTooth
  class << self
    attr_accessor :configuration

    def authorize_url(state = nil)
      oauth_client.auth_code.authorize_url :redirect_uri => configuration.redirect_uri, :state => state
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

  private

  class Configuration
    attr_accessor :client_id, :client_secret, :access_token_url, :authorization_url, :redirect_uri, :site
  end
end
