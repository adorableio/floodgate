require 'floodgate/version'

module Floodgate
  class Control
    def initialize(app)
      @app = app
    end

    def call(env)
      return @app.call(env) unless filter_traffic?

      if redirect_url.nil?
        [503, {}, ['Application Unavailable']]
      else
        [307, { 'Location' => redirect_url }, []]
      end
    end

    def filter_traffic?
      !ENV['FLOODGATE_FILTER_TRAFFIC'].nil?
    end

    def redirect_url
      ENV['MAINTENANCE_PAGE_URL']
    end

  end
end
