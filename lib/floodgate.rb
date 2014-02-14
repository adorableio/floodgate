require 'floodgate/version'

module Floodgate
  class Control
    def initialize(app, filter_traffic=false)
      @filter_traffic = filter_traffic
      @app = app
    end

    def call(env)
      return @app.call(env) unless @filter_traffic

      if maintenance_url = env['MAINTENANCE_PAGE_URL']
        [307, { 'Location' => maintenance_url }, []]
      else
        [503, {}, ['Application Unavailable']]
      end
    end
  end
end
