require 'object_schema/buildable'

class Array
  def self.of(*schemas, &defn)
    Array::Schema.new(*schemas, &defn)
  end
end

class Array::Schema < ObjectSchema::Schema
  include ObjectSchema::Buildable
  type :array
  build_methods :items, :item

  schema_accessor :min_items, :max_items

  def initialize(*schemas, &defn)
    schemas.map! { |schema|  ObjectSchema::Schema.instantiate(schema) }

    if schemas.size <= 1
      @items = []
      super(parent: self, schema: schemas.first, &defn)
    else
      @items = schemas
      super(parent: self, &defn)
    end
  end

  # require all array elements be unique
  def unique?
    @unique
  end
  def unique=(state)
    @unique = !!state
  end
  def unique(state = true)
    self.unique = state
  end

  def items(*schemas, &defn)
    return @items  unless schemas&.any? || defn
    schemas.map! { |schema|  ObjectSchema::Schema.instantiate(schema) }

    if schemas.size < 2
      @items = ObjectSchema::Builder.new(parent: self, schema: schemas.first, &defn).schema
    else
      @items = schemas
    end
  end
  def items=(*schemas)
    items(*schemas)
  end

  def item(name = nil, schema = nil, &defn)
    name, schema = normalize_opts(name, schema)
    return nil  unless schema || defn
    item = Schema::Builder.new(self, schema, &defn).schema
    item.name ||= name  if name
    @items << item
    item
  end

  schema_reader :extra
  def extra(name = nil, schema = nil, &defn)
    name, schema = normalize_opts(name, schema)
    @extra = Builder.new(self, schema, &defn)
    raise ArgumentError, "Expected Schema or false: #{schema.inspect}" unless !schema || schema.kind_of?(::Schema)
  end

  def as_json(**opts)
    super.update(
      minItems: min_items,
      maxItems: max_items,
      uniqueItems: unique?,
      items: @items.as_json,
      additionalItems: @extra&.as_json,
    ).reject { |_, v|  v.blank? }.as_json(**opts)
  end

protected
  def schema=(schema)
    item = super
    @items = @items&.any? ? (Array(@items) << item) :  item
    item
  end
end
