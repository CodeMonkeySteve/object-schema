require 'spec_helper'
require 'object_schema/types/datetime'

describe DateTime::Schema do
  it "#as_json" do
    schema = DateTime::Schema.new
    expect(schema.as_json.symbolize_keys).to eq( type: 'string', format: 'date_time' )
  end
end

describe Time::Schema do
  it "#as_json" do
    schema = Time::Schema.new
    expect(schema.as_json.symbolize_keys).to eq( type: 'number', format: 'utc_millisec' )
  end
end

describe Date::Schema do
  it "#as_json" do
    schema = Date::Schema.new
    expect(schema.as_json.symbolize_keys).to eq( type: 'string', format: 'date' )
  end
end
