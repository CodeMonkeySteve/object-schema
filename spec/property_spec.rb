require 'spec_helper'
require 'object_schema/property'

describe ObjectSchema::Property do
  let(:schema) { Class::Schema.new }

  describe "fields" do
    it ":required" do
      prop = schema.property(:foo, String)
      expect(prop.required?).to eq false
      prop.required
      expect(prop.required?).to eq true
      prop.required(false)
      expect(prop.required?).to eq false
    end

    it ":optional" do
      prop = schema.property(:foo, String)
      expect(prop.optional?).to eq true
      prop.optional(false)
      expect(prop.optional?).to eq false
      prop.optional
      expect(prop.optional?).to eq true
    end

    it ":identity" do
      prop = schema.property(:foo, String)
      expect(prop.identity?).to eq false
      prop.identity
      expect(prop.identity?).to eq true
      prop.identity(false)
      expect(prop.identity?).to eq false
    end

    it ":readonly" do
      prop = schema.property(:foo, String)
      expect(prop.readonly?).to eq false
      prop.readonly
      expect(prop.readonly?).to eq true
      prop.readonly(false)
      expect(prop.readonly?).to eq false
    end

    it ":requires" do
      prop = schema.property(:foo, String) { requires :bar }
      expect(prop.requires).to eq %i(bar)
    end

    it ":values" do
      prop = schema.property(:foo, String) { values :foo, :bar, :baaz }
      expect(prop.values).to eq %w(foo bar baaz)
    end

    it ":default" do
      prop = schema.property(:foo, String) { default "Hello" }
      expect(prop.default).to eq 'Hello'
    end
  end

  it "#as_json" do
    schema = ObjectSchema::Property.new(schema: String) do
      name 'foo'
      identity
      readonly
      requires :other
      values :foo, :bar
      default "Foo"
    end
    expect(schema.as_json.symbolize_keys).to match(
      type: 'string',
      name: 'foo',
      identity: true,
      readonly: true,
      requires: %w(other),
      enum: %w(foo bar),
      default: 'Foo'
    )
  end
end
