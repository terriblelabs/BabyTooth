require 'oauth2'

module HealthGrapher
  class << self
    attr_accessor :configuration
  end

  def self.authorize_url
    oauth_client.auth_code.authorize_url :redirect_uri => configuration.redirect_uri
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield self.configuration
  end

  class Configuration
    attr_accessor :client_id, :client_secret, :access_token_url, :authorization_url, :redirect_uri
  end

  private

  def self.oauth_client
    ::OAuth2::Client.new configuration.client_id, configuration.client_secret,
      :authorize_url => configuration.authorization_url,
      :token_url => configuration.access_token_url
  end
end
