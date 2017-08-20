require 'spec_helper'
require 'object_schema/class'
# require 'object_schema/types/string'

describe ObjectSchema::Class do
  subject { Class.new { include ObjectSchema::Class } }

  it ".schema" do
    expect(subject.schema).to be_a Class::Schema
  end

  it "#schema" do
    obj = subject.new
    expect(obj.schema).to eq obj.class.schema
  end
end
