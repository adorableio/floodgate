module Floodgate
  class Control
    attr_accessor :app, :config

    def initialize(app, app_id, api_token)
      Config.app_id = app_id
      Config.api_token = api_token

      @app = app
      @config = Config.new
    end

    def call(env)
      return app.call(env) unless filter_traffic?(env)

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

