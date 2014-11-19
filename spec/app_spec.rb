require "spec_helper"
require File.join(ROOT, "app")
require "rack/test"
require "securerandom"

describe Eqn do
  include Rack::Test::Methods

  def app; Eqn; end

  before(:each) do
    $redis.flushdb

    @equation = Equation.new "title" => "Test equation", "code" => "$$Test Equation$$"
    @equation.save
  end

  describe "GET /api/v1/equations/:id" do
    it "returns 404 if equation does not exist" do
      get "/api/v1/equations/1"
      expect(last_response.status).to eq(404)
    end

    it "returns existing equation" do
      get "/api/v1/equations/#{@equation.id}"

      expect(last_response).to be_ok
      expect(last_response.body).to eq({equation: @equation.to_hash}.to_json)
    end
  end

  describe "POST /api/v1/equations" do
    it "returns 422 with invalid data" do
      post "/api/v1/equations", equation: { invalid_key: "test" }

      expect(last_response.status).to eq(422)
    end

    it "returns 200 and saves equation with valid data" do
      post "/api/v1/equations", equation: { title: "Test", code: "$$Test$$" }

      new_equation_id = JSON.load(last_response.body)["equation"]["id"]
      new_equation = Equation.find(new_equation_id)

      expect(last_response).to be_ok
      expect(new_equation).not_to eq(nil)
    end
  end

  describe "PATCH /api/v1/equations/:id" do
    it "returns 422 with invalid data" do
      patch "/api/v1/equations/#{@equation.id}", equation: { invalid_key: "test" }

      expect(last_response.status).to eq(422)
    end

    it "returns 200 and saves equation with valid data" do
      patch "/api/v1/equations/#{@equation.id}", equation: { title: "New Title" }

      updated_equation = Equation.find(@equation.id)

      expect(last_response).to be_ok
      expect(updated_equation["title"]).to eq("New Title")
    end
  end

end
