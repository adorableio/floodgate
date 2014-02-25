# TODO: Use a real client real soon now, but not now
require 'open-uri'
require 'json'

module Floodgate
  class Config
    attr_accessor :app_id, :api_token, :filter_traffic, :redirect_url

    def initialize(app_id, api_token)
      @app_id = app_id
      @api_token = api_token

      json = Client.status(app_id, api_token)

      @filter_traffic = json['filter_traffic']
      @redirect_url = json['redirect_url']
    end

    def redirect?
      !redirect_url.nil? && !redirect_url.empty?
    end

    def filter_traffic?(env)
      filter_traffic

      # TODO: Use env
    end
  end
end
