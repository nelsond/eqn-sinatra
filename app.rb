require "#{File.dirname(__FILE__)}/config/environment"

require "json"

require "sinatra/json"
require "sinatra/namespace"
require "sinatra/assetpack"

require "active_support"
require "active_support/inflector"

class Eqn < Sinatra::Base
  register Sinatra::Namespace
  register Sinatra::AssetPack

  helpers Sinatra::JSON

  enable :logging
  enable :method_override

  set :root, File.dirname(__FILE__)
  set :views, "#{ROOT}/views"
  set :scss, { load_paths: [ "#{ROOT}/assets/stylesheets/" ] }

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

  assets do |a|
    break if test?

    a.serve "/js", from: "assets/javascripts"
    a.serve "/css", from: "assets/stylesheets"
    a.serve "/images", from: "assets/images"

    a.js :app, [
      "/js/lib/showdown.js",
      "/js/lib/moment.js",
      "/js/lib/handlebars-v1.1.0.js",
      "/js/lib/ember.js",
      "/js/lib/ember-data.js",
      "/js/application.js",
      "/js/components/*.js",
      "/js/helpers.js",
      "/js/models/*.js",
      "/js/controllers/*.js",
      "/js/router.js"
    ]

    a.css :app, [ "/css/application.css" ]

    a.js_compression :uglify
    a.css_compression :sass

    a.prebuild true
  end

  helpers do
    def underscore(h)
      h.keys.each do |k|
        next if k.underscore == k

        h[k.underscore] = h[k]
        h.delete k
      end
      h
    end
  end

  namespace "/api/v1" do
    namespace "/equations" do

      get "/:id/?" do
        equation = Equation.find params[:id]

        if equation
          status 200
          json equation: equation.to_hash
        else
          status 404
          json msg: "Equation #{params[:id]} not found."
        end
      end

      post "/?" do
        equation = Equation.new underscore(params[:equation])

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

  get "*" do
    haml :index
  end

end
