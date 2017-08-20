require 'object_schema/schema'
require 'object_schema/property'

class Hash::Schema < ObjectSchema::Schema
  include ObjectSchema::Buildable
  type :object

  attr_reader :properties

  def initialize(parent: nil, schema: nil, &defn)
    @properties = {}
    super
  end

  def property(name = nil, schema = nil, &defn)
    name, schema = normalize_opts(name, schema)
    prop = ObjectSchema::Property.new(parent: self, schema: schema, &defn)
    name ||= prop.name
    raise "Property #{prop.inspect} cannot be annonymous"  if name.nil? || name.empty?
    @properties[name.to_sym] = prop
  end

  schema_reader :extra
  def extra(name = nil, schema = nil, &defn)
    _name, schema = normalize_opts(name, schema)
    @extra = Builder.new(self, schema, &defn)
    raise ArgumentError, "Expected Schema or false: #{@extra.inspect}"  unless schema.is_a?(ObjectSchema::Schema)
  end

  def get(obj, prop_name)
    obj[prop_name.to_s]
  end

  def set(obj, prop_name, value)
    obj[prop_name.to_s] = value
  end

  def as_json(**opts)
    super.update(
      properties: Hash[@properties.map { |k, v|  [ k, v.as_json(opts[k] || {}) ] }],
      additionalProperties: @extra && @extra.as_json,
      required: @properties.select { |_, v|  v.required? }.keys.map(&:to_s),
    ).reject { |_, v|  v.blank? }.as_json(**opts)
  end
end
