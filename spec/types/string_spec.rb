require 'spec_helper'
require 'object_schema/types/string'

describe String::Schema do
  describe :fields do
    it :pattern do
      schema = String::Schema.new { pattern /foo/ }
      expect(schema.pattern).to eq /foo/
    end

    it :form do
      schema = String::Schema.new { form :color }
      expect(schema.form).to eq :color
      expect { schema.form 'invalid' }.to raise_error(ArgumentError)
    end

    it :min_length do
      schema = String::Schema.new { min_length 42 }
      expect(schema.min_length).to eq 42
    end

    it :max_length do
      schema = String::Schema.new { max_length 100 }
      expect(schema.max_length).to eq 100
    end
  end

  it "#as_json" do
    schema = String::Schema.new { pattern /^foo$/ ; form :color ; min_length 42 }
    expect(schema.as_json.symbolize_keys).to eq( type: 'string', pattern: /^foo$/.as_json, format: 'color', minLength: 42 )
  end
end
