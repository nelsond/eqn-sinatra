source "https://rubygems.org"

ruby "2.1.2"

# rake
gem "rake", "~> 10.3"

# sinatra
gem "sinatra"
gem "sinatra-contrib", require: false

# active support
gem "activesupport", "~> 4.1", require: false

# thin web server
gem "thin", "~> 1.6.3"

# redis
gem "hiredis", "~> 0.5.2"
gem "redis", ">= 3.1.0", require: ["redis", "redis/connection/hiredis"]

# json post body
gem "rack-parser", require: "rack/parser"

# development only
group :development do
  gem "foreman"
end

# test only
group :test do
  gem "rspec"
  gem "simplecov"
  gem "kicker", require: false
end
