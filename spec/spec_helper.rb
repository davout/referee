require 'pry'
require 'webmock/rspec'
require 'simplecov'

SimpleCov.start

require(File.expand_path('../../lib/referee', __FILE__))

RSpec.configure do |config|
  config.mock_with :rspec
end 

