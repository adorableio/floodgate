require 'floodgate/version'

module Floodgate
  class Control
    def initialize(app)
      @app = app
    end

    def call(env)
      return @app.call(env) unless filter_traffic?

      if redirect?
        [307, { 'Location' => redirect_url }, []]
      else
        [503, {}, ['Application Unavailable']]
      end
    end

    def filter_traffic?
      !(ENV['FLOODGATE_FILTER_TRAFFIC'].nil? || ENV['FLOODGATE_FILTER_TRAFFIC'] == '')
    end

    def redirect?
      !(redirect_url.nil? || redirect_url == '')
    end

    def redirect_url
      ENV['MAINTENANCE_PAGE_URL']
    end

  end
end
