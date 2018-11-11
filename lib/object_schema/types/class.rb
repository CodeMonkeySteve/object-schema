require_relative 'hash'
require_relative 'function'

class Class::Schema < Hash::Schema
  build_methods :property, :function, :func

  attr_reader :functions

  def initialize(&defn)
    @functions = {}
    super
  end

  def function(name = nil, &defn)
    func = Function::Schema.new(&defn)
    @functions[(name || func.name).to_sym] = func
  end
  alias :func :function

  def get(obj, prop_name)
    # TODO: access control
    obj.__send__(prop_name.to_sym)
  end

  def set(obj, prop_name, value)
    # TODO: access control
    obj.__send__("#{prop_name}=".to_sym, value)
  end

  def each(obj, &blk)
    obj.each(&blk)
  end

  def as_json(**opts)
    super.update(
      functions: Hash[@functions.map { |k, v| [ k, v.as_json(opts[k] || {}) ] }],
    ).reject { |_, v|  v.blank? }.as_json(**opts)
  end
end
