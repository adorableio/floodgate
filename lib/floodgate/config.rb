module Floodgate
  class Config
    attr_accessor \
      :allowed_ip_addresses,
      :api_token,
      :app_id,
      :filter_traffic,
      :redirect_url

    def initialize(app_id, api_token)
      @app_id = app_id
      @api_token = api_token

      json = Client.status(app_id, api_token)

      @filter_traffic = json['filter_traffic']
      @redirect_url = json['redirect_url']
      @allowed_ip_addresses = json['allowed_ip_addresses'] || []
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
  end
end
