require 'floodgate/version'

module Floodgate
  class Control
    def initialize(app)
      @app = app
    end

    def filter_traffic?
      !ENV['FLOODGATE_FILTER_TRAFFIC'].nil?
    end

    def call(env)
      return @app.call(env) unless filter_traffic?

      if maintenance_url = ENV['MAINTENANCE_PAGE_URL']
        [307, { 'Location' => maintenance_url }, []]
      else
        [503, {}, ['Application Unavailable']]
      end
    end
  end
end
