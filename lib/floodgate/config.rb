module Floodgate
  class Config
    class << self
      attr_accessor :app_id, :api_token

      def reset
        @app_id = @api_token = nil
      end
    end

    attr_accessor \
      :allowed_ip_addresses,
      :filter_traffic,
      :redirect_url

    def initialize
      status = Client.status

      @filter_traffic = status.filter_traffic
      @redirect_url = status.redirect_url
      @allowed_ip_addresses = status.allowed_ip_addresses
    end

    def potential_client_addresses(env)
      %w(REMOTE_ADDR HTTP_X_FORWARDED_FOR).map { |name| env[name] }
    end

    def client_allowed?(env)
      !!potential_client_addresses(env).find do |ip_address|
        allowed_ip_addresses.include?(ip_address)
      end
    end

    def filter_traffic?(env)
      filter_traffic && !client_allowed?(env)
    end

    def redirect?
      !redirect_url.nil? && !redirect_url.empty?
    end

    def reset
      @redirect_url = nil
      @filter_traffic = false
    end
  end
end
