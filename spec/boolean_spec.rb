require 'spec_helper'
require 'object_schema/types/boolean'

describe ObjectSchema::Boolean do
  it "#as_json" do
    expect(subject.as_json.symbolize_keys).to eq(type: 'boolean')
  end
end
