require "./app"

use Rack::ShowExceptions
use Rack::Deflater
use Rack::Runtime
use Rack::Parser, parsers: { "application/json" => proc { |data| JSON.parse data } }

run Eqn
