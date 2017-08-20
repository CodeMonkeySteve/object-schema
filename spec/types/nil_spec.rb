require 'spec_helper'
require 'object_schema/types/nil'

describe NilClass::Schema do
  it "#as_json" do
    schema = NilClass::Schema.new
    expect(schema.as_json.symbolize_keys).to eq( type: 'null' )
  end
end
