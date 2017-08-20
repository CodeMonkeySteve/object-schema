require 'spec_helper'

describe ObjectSchema::Schema do
  describe "fields" do
    subject(:schema) { described_class.new }

    it ":type" do
      schema.class.type('number')
      expect(schema.class.type).to eq :number
      schema.class.type(:integer)
      expect(schema.class.type).to eq :integer
      expect { schema.class.type('invalid') }.to raise_error(ArgumentError)
    end

    it ":name" do
      schema.name = "Some thing"
      expect(schema.name).to eq "Some thing"
    end

    it ":description" do
      schema.description = "Description"
      expect(schema.description).to eq "Description"
    end
  end

  describe ".instantiate" do
    it "nil does nothing" do
      expect(described_class.instantiate(nil)).to eq nil
    end

    it "Schema instance does nothing" do
      schema = String::Schema.new
      expect(described_class.instantiate(schema)).to eq schema
    end

    it "Schema class instantiates" do
      expect(described_class.instantiate(String::Schema)).to be_a String::Schema
    end

    it "Class instantiates using its Schema" do
      expect(described_class.instantiate(String)).to be_a String::Schema
    end

    it "Array creates Array schema" do
      schema = described_class.instantiate([String, Numeric])
      expect(schema).to be_a Array::Schema
      expect(schema.items.map(&:class)).to eq [String::Schema, Numeric::Schema]
    end
  end
end
