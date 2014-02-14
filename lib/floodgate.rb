require 'floodgate/version'

module Floodgate
  class Control
    def initialize(app)
      @app = app
    end

    def filter_traffic?(env)
      !env['FLOODGATE_FILTER_TRAFFIC'].nil?
    end

    def call(env)
      return @app.call(env) unless filter_traffic?(env)

      if maintenance_url = env['MAINTENANCE_PAGE_URL']
        [307, { 'Location' => maintenance_url }, []]
      else
        [503, {}, ['Application Unavailable']]
      end
    end
  end
end
