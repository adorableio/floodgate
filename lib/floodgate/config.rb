module Floodgate
  class Config
    attr_accessor :filter_traffic, :redirect_url

    def initialize(filter_traffic = false, redirect_url = nil)
      @filter_traffic = filter_traffic
      @redirect_url = redirect_url
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
