require 'object_schema/buildable'
require 'active_support/callbacks'

# Hash/Class Property
class ObjectSchema::Property
  include ObjectSchema::Buildable

  def initialize(parent: nil, schema: nil, &defn)
    @required = @identity = @readonly = false  # @transient
    super
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

  def identity?
    @identity
  end
  def identity=( state )
    @identity = !!state
  end
  def identity(state = true)
    self.identity = state
  end

  def readonly?
    @readonly
  end
  def readonly=( state )
    @readonly = !!state
  end
  def readonly(state = true)
    self.readonly = state
  end

  def requires(*requires)
    return @requires  if requires.empty?
    requires.map!(&:to_sym)
#     requires.each do |prop|
#       raise ArgumentError, "Unknown property: #{prop.inspect}" unless @parent.properties.include?(prop)
#     end
    @requires = requires
  end
  alias_method :require=, :require

  # aka ENUM
  def values(*values)
    return @values  if values.empty?
    values.map!(&:to_s)
    #for val in vals
    #  raise TypeError, "Value not valid: #{val.inspect}"  unless self.validate!( val )
    #end
    @values = values
  end
  alias_method :values=, :values

  def default(*value)
    return @default  if value.empty?
    default = value[0]
    #raise TypeError, "Default value not valid: #{val.inspect}"  unless self.validate!( val )
    @default = default
  end
  alias_method :default=, :default

  def as_json(**opts)
    self.schema.as_json(opts).update(
      identity: identity?,
      readonly: readonly?,
      default:  default&.as_json,
      requires: requires&.map(&:to_s),
      enum:     values&.map(&:as_json),
    ).reject { |_, v|  v.blank? }.as_json(**opts)
  end
end
