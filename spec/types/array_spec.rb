require 'spec_helper'
require 'object_schema/types/array'
require 'object_schema/types/string'
require 'object_schema/types/numeric'

describe Array::Schema do
  describe "fields" do
    it ":min_items" do
      schema = Array::Schema.new { min_items 1 }
      expect(schema.min_items).to eq 1
    end

    it ":max_items" do
      schema = Array::Schema.new { max_items 10 }
      expect(schema.max_items).to eq 10
    end

    it ":unique" do
      schema = Array::Schema.new { unique }
      expect(schema.unique?).to eq true
    end

    it ":items" do
      schema = Array::Schema.new
      expect(schema.items).to eq []

      schema = Array::Schema.new(String)
      expect(schema.items).to be_a String::Schema

      schema = Array::Schema.new { items Float }
      expect(schema.items).to be_a Numeric::Schema

      schema = Array::Schema.new { items String, Numeric }
      expect(schema.items.map(&:class)).to eq [String::Schema, Numeric::Schema]
    end
  end

  it ".of" do
    # mock(Array::Schema).new(String)
    Array.of(String)

    # mock(Array::Schema).new(String, Numeric)
    Array.of(String, Numeric)
  end

  it "#as_json" do
    schema = Array::Schema.new { items String ; min_items 2 ; max_items 4 ; unique }
    expect(schema.as_json.symbolize_keys).to eq(
      type: 'array',
      minItems: 2,
      maxItems: 4,
      uniqueItems: true,
      items: String::Schema.new.as_json
    )
  end
end

