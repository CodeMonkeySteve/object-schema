require 'active_support/core_ext'

Function = Proc
class Function::Schema < ObjectSchema::Schema
  include ObjectSchema::Buildable
  type :function
  attr_reader :params, :options, :returns

  def initialize(&defn)
    @params = []
    @options = {}
    @returns = nil
    super
  end

  def param(name = nil, schema = nil, &defn)
    name, schema = normalize_opts(name, schema)
    param = ObjectSchema::Param.new(parent: self, schema: schema, &defn)
    param.name ||= name
    @params << param
  end

  def option(name = nil, schema = nil, &defn)
    name, schema = normalize_opts(name, schema)
    option = ObjectSchema::Param.new(parent: self, schema: schema, option: true, &defn)
    name = option.name = (option.name || name)
    raise "Options must have name"  if name.blank?
    raise "Option #{name} already defined"  if @options.has_key?(name.to_sym)
    @params << option
  end

  def returns(schema = nil, &defn)
    @returns = ObjectSchema::Builder.new(parent: self, schema: schema, &defn).schema
  end

  def params(*schemas, &defn)
    @params = schemas.map { |schema|  Schema.instantiate(schema) }
    self.instance_eval(&defn)  if defn
  end

  def as_json(**opts)
    params = @params.sort_by { |param|  param.option ? 1 : 0 }   # sort Options last
    super.merge(
      params: params.map(&:as_json),
      returns: @returns,
    ).reject { |_, v|  v.blank? }.as_json(**opts)
  end
end
