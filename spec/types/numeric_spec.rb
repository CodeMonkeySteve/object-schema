require 'spec_helper'
require 'object_schema/types/numeric'

describe Numeric::Schema do
  describe :fields do
    it :minimum do
      schema = Numeric::Schema.new { minimum 12.34 }
      expect(schema.minimum).to eq 12.34
    end

    it :maximum do
      schema = Numeric::Schema.new { maximum 56.78 }
      expect(schema.maximum).to eq 56.78
    end
  end

  it "#as_json" do
    schema = Numeric::Schema.new { minimum 12.34 ; maximum 56.78 }
    expect(schema.as_json.symbolize_keys).to eq( type: 'number', minimum: 12.34, maximum: 56.78 )
  end
end

describe Integer::Schema do
  it "#as_json" do
    schema = Integer::Schema.new { minimum 42 ; maximum 100 }
    expect(schema.as_json.symbolize_keys).to eq( type: 'integer', minimum: 42, maximum: 100 )
  end
end
