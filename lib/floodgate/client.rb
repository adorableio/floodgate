require 'faraday'
require 'faraday_middleware'
require 'hashie'

module Floodgate
  class Client
    def self.add_ip_address(ip_address)
      return if ip_address.nil? || ip_address.empty?

      params = { ip_address: { ip_address: ip_address } }

      post('ip_addresses', params)
    end

    def self.allowed_ip_addresses
      status.allowed_ip_addresses
    end

    def self.close
      params = { app: { filter_traffic: true } }

      put('', params)
    end

    def self.open
      params = { app: { filter_traffic: false } }

      put('', params)
    end

    def self.remove_ip_address(ip_address)
      return if ip_address.nil? || ip_address.empty?

      params = { ip_address: { ip_address: ip_address } }

      delete('ip_addresses', params)
    end

    def self.set_redirect_url(redirect_url)
      params = { app: { redirect_url: redirect_url } }

      put('', params)
    end

    def self.default_status
      Hashie::Mash.new(
        default_status: true,
        filter_traffic: false,
        allowed_ip_addresses: [],
        redirect_url: nil
      )
    end

    def self.status
      begin
        get('status')
      rescue Faraday::Error::ClientError => e
        # TODO: Log
        default_status
      end
    end

    def self.delete(path, params = {})
      verb_with_params_in_body(:delete, path, params)
    end

    def self.get(path, params = {})
      params.merge!(api_token: Config.api_token)

      response = get_connection.get(path, params)

      response.body
    end

    def self.post(path, params = {})
      verb_with_params_in_body(:post, path, params)
    end

    def self.put(path, params = {})
      verb_with_params_in_body(:put, path, params)
    end

    def self.verb_with_params_in_body(verb, path, params = {})
      params.merge!(api_token: Config.api_token)

      response = get_connection.public_send(verb, path) do |request|
        request.body = params
      end

      response.body
    end

    def self.base_url
      "https://floodgate-api-staging.herokuapp.com/api/v1/apps/#{Config.app_id}"
    end

    def self.user_agent
      'FloodgateAgent'
    end

    def self.get_connection
      conn = Faraday.new(url: base_url) do |builder|
        builder.use Faraday::Response::Mashify
        builder.use FaradayMiddleware::ParseJson, content_type: 'application/json'
        builder.use Faraday::Request::UrlEncoded
        builder.use Faraday::Response::RaiseError
        builder.use Faraday::Adapter::NetHttp
      end

      conn.headers[:user_agent] = user_agent

      conn
    end
  end
end

