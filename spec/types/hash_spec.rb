require 'spec_helper'
require 'object_schema/types/hash'

describe Hash::Schema do
  let(:schema) { Hash::Schema.new }

  it "#property" do
    schema.property(:id, String)
    expect(schema.properties.keys).to eq %i(id)
    expect(schema.properties[:id].instance_variable_get(:@schema).class).to eq String::Schema
  end

  it "#set" do
    hash = { 'foo' => 45 }
    expect( schema.get(hash, :foo) ).to eq 45
  end

  it "#set" do
    hash = {}
    schema.set(hash, :foo, 42)
    expect(hash).to eq( 'foo' => 42 )
  end

  it "#as_json" do
    schema = Hash::Schema.new { property(:foo, String) { required } }
    expect(schema.as_json.deep_symbolize_keys).to eq(
      type: 'object',
      properties: {
        foo: String::Schema.new.as_json.symbolize_keys
      },
      required: %w(foo)
    )
  end
end
