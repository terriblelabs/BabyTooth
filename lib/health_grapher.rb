module HealthGrapher
  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield self.configuration
  end

  class Configuration
    attr_accessor :client_id, :client_secret, :access_token_url, :authorization_url
  end

end
