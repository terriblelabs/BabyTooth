require 'oauth2'

module BabyTooth
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

  def self.get_token(authorization_code)
    oauth_client.auth_code.get_token(authorization_code,
      :redirect_uri => configuration.redirect_uri).token
  end

  def self.oauth_client
    ::OAuth2::Client.new configuration.client_id, configuration.client_secret,
      :authorize_url => configuration.authorization_url,
      :token_url => configuration.access_token_url
  end

  private

  class Configuration
    attr_accessor :client_id, :client_secret, :access_token_url, :authorization_url, :redirect_uri
  end
end
