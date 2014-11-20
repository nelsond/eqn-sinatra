ENV["RACK_ENV"] = "test"

require "rubygems"
require "bundler"

Bundler.require(:test)

SimpleCov.start do
  add_filter "/spec/"
  add_filter "/config/"
  add_filter "/initializers/"

  add_group "Libraries", "lib/"
  add_group "Sinatra", "app"
end

require File.expand_path("../config/environment", File.dirname(__FILE__))
Dir["#{ROOT}/spec/support/*.rb"].each { |file| require file }


RSpec.configure do |config|
  $redis = Redis.new(url: ENV["REDIS_URL"], logger: $logger)
  $redis.client.db = 2
  $redis.flushdb
  config.after(:all) { $redis.flushdb }
end
