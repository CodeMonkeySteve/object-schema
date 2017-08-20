require 'spec_helper'
require 'object_schema/extensions/access_control'

xdescribe ObjectSchema::AccessControl do
  let(:schema) do
    Class.new(ObjectSchema::Schema) { include ObjectSchema::AccessControl }.schema
  end

  it "#grant" do
    prop = schema.property(:foo, String) do
      grant :all, :user
      deny :frob, :all
      grant :frob, :user
    end
    user = stub!.user? { true }.subject
    expect( prop.authorize(:frob, user) ).to eq true
  end

  it "#deny" do
    prop = schema.property(:foo, String) do
      grant :all, :user
      deny :frob, :all
      grant :frob, :user
    end
    user = stub!.user? { false }.subject
    expect( prop.authorize(:frob, user) ).to eq false
  end

  it "#read" do
  end

  it "#write" do
  end

  it "#readonly" do
  end
end
