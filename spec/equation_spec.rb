require "spec_helper"

describe Equation do
  before(:each) { $redis.flushdb }

  context "with a saved Equation" do
    before(:each) do
      @equation = Equation.new "code" => "$$Test Equation$$"
      @equation.save
    end

    describe ".find" do
      it "should find the Equation" do
        found_equation = Equation.find(@equation.id)
        expect(found_equation).to eq(@equation)
      end
    end

    describe ".delete" do
      it "should delete the Equation" do
        equation_deleted = Equation.delete(@equation.id)
        deleted_equation = Equation.find(@equation.id)

        expect(equation_deleted).to eq(true)
        expect(deleted_equation).to eq(nil)
      end

      it "should return false if Equation doesn't exist" do
        equation_deleted = Equation.delete("ab")

        expect(equation_deleted).to eq(false)
      end
    end
  end

  describe "#save" do
    it "should save a new Equation" do
      equation = Equation.new "code" => "$$Test Equation$$"

      expect(equation.save).to eq(true)
      expect(equation.id).not_to eq(nil)
    end

    it "should save an existing Equation with a new hash id" do
      equation = Equation.new "code" => "$$Test Equation$$"
      equation.save

      rev_equation = Equation.new "code" => "$$Test Equation$$"
      rev_equation.save

      expect(equation.id).not_to eq(rev_equation.id)
    end

    it "should not save an invalid Equation" do
      equation = Equation.new
      expect(equation.save).to eq(false)

      equation = Equation.new "invalid_key" => "Test"
      expect(equation.save).to eq(false)
    end
  end
end
