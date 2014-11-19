require "spec_helper"

describe Equation do
  before(:each) { $redis.flushdb }

  context "with a saved Equation" do
    before(:each) do
      @equation = Equation.new "title" => "Test equation", "code" => "$$Test Equation$$"
      @equation.save
    end

    #describe ".all" do
      #it "should return all Equations" do
        #4.times do |i|
          #e = Equation.new "title" => "Test equation #{i}", "code" => "$$Test Equation$$"
          #e.save
        #end

        #expect(Equation.all).to eq(5)
      #end
    #end

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

    describe ".update" do
      it "should update the Equation" do
        new_title = "Updated Title"
        equation_updated = Equation.update(@equation.id, "title" => new_title)

        updated_equation = Equation.find(@equation.id)

        expect(equation_updated).to eq(true)
        expect(updated_equation["title"]).to eq(new_title)
      end
    end
  end

  describe "#save" do
    it "should save a new Equation" do
      equation = Equation.new "title" => "Test equation", "code" => "$$Test Equation$$"

      expect(equation.save).to eq(true)
      expect(equation.id).not_to eq(nil)
    end

    #it "should not save an invalid Equation" do
      #equation = Equation.new
      #expect(equation.save).to eq(false)

      #equation = Equation.new "invalid_key" => "Test"
      #expect(equation.save).to eq(false)
    #end
  end
end
