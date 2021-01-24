require 'object_schema/buildable'

# Function Parameter
class ObjectSchema::Param
  include ObjectSchema::Buildable
  attr_reader :option

  def initialize(parent: nil, schema: nil, option: false, &defn)
    @required = false
    @option = false
    super(parent: parent, schema: schema, &defn)
  end

  def required?
    @required
  end
  def required=( state )
    @required = !!state
  end
  def required(state = true)
    self.required = state
  end

  def optional?
    !@required
  end
  def optional=( state )
    @required = !state
  end
  def optional(state = true)
    self.optional = state
  end

  # aka ENUM
  def values(*values)
    return @values  if values.empty?
    @values = values
  end
  alias_method :values=, :values

  def default(*value)
    return @default  if value.empty?
    default = value[0]
    @default = default
  end
  alias_method :default=, :default

  def as_json(**opts)
    schema.as_json(**opts).update(
      option:   option || nil,
    ).reject { |_, v|  v.blank? }.as_json(**opts)
  end
end
