require 'oauth2'
require 'faraday_stack'

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
    attr_reader :body

    def [](key)
      body[key]
    end

    def initialize(access_token, path)
      self.access_token = access_token
      self.path = path
      retrieve!
    end

    def resource_class_name
      self.class.name.split('::').last
    end

    protected

    def retrieve!
      @body = connection.get(path) do |request|
        request.headers['Authorization'] = "Bearer #{access_token}"
        request.headers['Accept'] = "application/vnd.com.runkeeper.#{resource_class_name}+json"
      end.body
    end

    def connection
      FaradayStack.build ::BabyTooth.configuration.site
    end
  end

  class User < Client
    def initialize(access_token)
      super access_token, '/user'
    end

    def profile
      @profile ||= Profile.new(access_token, self['profile'])
    end

  end

  class Profile < Client
  end

  private

  class Configuration
    attr_accessor :client_id, :client_secret, :access_token_url, :authorization_url, :redirect_uri, :site
  end
end
