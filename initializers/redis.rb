require "redis"
require "redis/connection/hiredis"

$redis = Redis.new(url: ENV["REDIS_URL"], logger: $logger)
