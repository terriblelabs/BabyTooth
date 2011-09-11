module BabyTooth
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
end
