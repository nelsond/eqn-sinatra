ROOT = File.expand_path("..", File.dirname(__FILE__)) unless defined? ROOT

ENV["RACK_ENV"] ||= "development"

require "rubygems"
require "bundler"
Bundler.setup(:default, ENV["RACK_ENV"])
Bundler.require

unless ENV["RACK_ENV"] == "test"
  require "active_support/logger"
  $logger = ActiveSupport::Logger.new(STDOUT)
  $stdout.sync = true
end

Dir["#{ROOT}/initializers/*.rb"].each { |file| require file }
