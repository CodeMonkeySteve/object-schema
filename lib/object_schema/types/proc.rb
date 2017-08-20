# require 'object_schema/proc'

class Proc::Schema < ObjectSchema::Schema
  def initialize(&defn)
    @params = []
    @returns = nil
    super
  end

  def params(*schemas, &defn)
    @params = schemas.map { |schema|  Schema.instantiate(schema) }
    self.instance_eval(&defn)  if defn
  end

  def param(name = nil, schema = nil, &defn)
    name, schema = normalize_opts(name, schema)
    @params ||= []
    @params << ObjectSchema::Builder.new(parent: self, schema: schema, &defn).schema
  end

  def returns(schema = nil, &defn)
    @returns = ObjectSchema::Builder.new(parent: self, schema: schema, &defn).schema
  end

  # def idempotent
  # end

  def as_json(**opts)
    {
      params: @params.as_json,
      returns: @returns.as_json,
    }.reject { |_, v|  v.blank? }.as_json(**opts)
  end
end
