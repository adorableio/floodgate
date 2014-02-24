require 'floodgate/version'

module Floodgate
  class Control
    def initialize(app, config)
      @app = app
      @config = config
    end

    def call(env)
      return @app.call(env) unless filter_traffic?(env)

      if redirect?
        [307, { 'Location' => redirect_url }, []]
      else
        [503, {}, ['Application Unavailable']]
      end
    end

    def filter_traffic?(env)
      config.filter_traffic?(env)
    end

    def redirect?
      config.redirect?
    end

    def redirect_url
      config.redirect_url
    end
  end
end

