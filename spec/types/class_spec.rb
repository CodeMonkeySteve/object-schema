require 'spec_helper'
require 'object_schema/types/class'

describe Class::Schema do
  let(:schema) { Class::Schema.new }

  it "#func" do
    schema.func(:stuff)
    expect(schema.functions[:stuff]).to be_a(Proc::Schema)
  end

  it "#get" do
    obj = double
    expect(obj).to receive(:foo).and_return(42)
    expect(schema.get(obj, :foo)).to eq 42
  end

  it "#set" do
    obj = double
    expect(obj).to receive(:foo=).and_return(42)
    schema.set(obj, :foo, 42)
  end

  it "#as_json" do
    schema = Class::Schema.new { func :foo }
    expect(schema.as_json.deep_symbolize_keys).to eq(
      type: 'object',
      functions: { foo: {} }
    )
  end
end
