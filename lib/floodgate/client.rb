require 'json'
require 'open-uri'

module Floodgate
  class Client
    def self.status(app_id, api_token)
      # TODO: Handle errors, timeouts, proxies, environments, etc.
      JSON.parse(open("https://floodgate-api-staging.herokuapp.com/api/v1/apps/#{app_id}/status?api_token=#{api_token}").read)
    end
  end
end
