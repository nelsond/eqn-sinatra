require "#{File.dirname(__FILE__)}/config/environment"

require "json"

require "sinatra/json"
require "sinatra/namespace"

require "active_support"
require "active_support/inflector"

class Eqn < Sinatra::Base
  register Sinatra::Namespace

  helpers Sinatra::JSON

  enable :logging
  enable :method_override

  set :root, File.dirname(__FILE__)
  set :static_cache_control, [:public, max_age: 60*60*24*365]
  set :views, "#{ROOT}/views"

  # :nocov:
  configure :development do
    require "sinatra/reloader"

    register Sinatra::Reloader
    Dir["#{ROOT}/intializers/*.rb",
        "#{ROOT}/lib/*.rb"].each do |file|
      also_reload file
    end
  end
  # :nocov:

  configure :production do
    before do
      redirect("http://eqn.io#{request.path}") if request.host != "eqn.io"
    end
  end

  configure do
    require "digest"

    asset_fingerprints = {}

    Dir["#{ROOT}/public/**/*.{css,js}"].each do |file|
      asset_path = file.gsub(/^#{Regexp.escape("#{ROOT}/public/")}/, "")
      asset_fingerprints[asset_path] = Digest::MD5.file(file).hexdigest[0..9]
    end

    set :asset_fingerprints, asset_fingerprints
  end

  helpers do
    def asset_path(path)
      path.gsub!(/\.(js|css)$/, '.min.\1') if settings.environment == :production

      "/#{path}?#{settings.asset_fingerprints[path]}"
    end
  end

  namespace "/api/v1" do
    namespace "/equations" do

      get "/:id/?" do
        equation = Equation.find params[:id]

        if equation
          status 200

          last_modified Time.at(equation.values["created_at"])
          etag equation.id

          json equation: equation.to_hash
        else
          status 404
          json msg: "Equation #{params[:id]} not found."
        end
      end

      post "/?" do
        equation = Equation.new params[:equation]

        if equation.save
          status 200
          json equation: equation.to_hash
        else
          status 422
          json msg: "Invalid data."
        end
      end

    end
  end

  get "/?:id?" do
    erb :app
  end

end
