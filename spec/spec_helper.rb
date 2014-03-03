require 'simplecov'

SimpleCov.start do
  add_filter '/spec/'
end

require 'rspec'

require 'floodgate'

ENV['FLOODGATE_TEST_MODE'] = 'TRUE'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[File.expand_path(File.join(__FILE__, '../support/**/*.rb'))].each { |f| require f }

