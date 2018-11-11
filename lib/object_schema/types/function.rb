require 'active_support/core_ext'

Function = Proc
class Function::Schema < ObjectSchema::Schema
  include ObjectSchema::Buildable
  type :function

  def initialize(&defn)
    @params = []
    @returns = nil
    super
  end

  def param(name = nil, schema = nil, &defn)
    name, schema = normalize_opts(name, schema)
    param = ObjectSchema::Param.new(parent: self, schema: schema, &defn).schema
    # param.name = name
    @params << param
  end

  def returns(schema = nil, &defn)
    @returns = ObjectSchema::Builder.new(parent: self, schema: schema, &defn).schema
  end

  def params(*schemas, &defn)
    @params = schemas.map { |schema|  Schema.instantiate(schema) }
    self.instance_eval(&defn)  if defn
  end

  def as_json(**opts)
    super.merge(
      params: @params.map(&:as_json),
      returns: @returns,
    ).reject { |_, v|  v.blank? }.as_json(**opts)
  end
end
