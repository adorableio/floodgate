require 'floodgate'
require 'rails'

module Floodgate
  class Railtie < Rails::Railtie
    railtie_name :floodgate

    rake_tasks do
      load 'tasks/floodgate_tasks.rake'
    end
  end
end

