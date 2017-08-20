require 'active_support/concern'

module Schema::Accessors
  extend ActiveSupport::Concern

  included do
    raise "Schema #{schema.inspect} has no properties"  unles props = self.schema.properties
    generated_methods.module_eval do

    props.each do |name, prop|
      define_method prop, ""
    end
  end

  def initialize(*args)
    @_watch_props ||= {}
    super
  end

  def get(*attrs, &on_change)
    vals = attrs.map do |attr|
      if attr.is_a?(Symbol)
        return self.instance_variable_get("@#{attr}")

      elsif attr.is_a?(String)
        attr = attr.split('.')
        return self.instance_variable_get("@#{attr.shift}")  if attr.size == 1
        # fall-through
      end

      if attr.is_a?(Array)
        val = self.instance_variable_get("@#{attr.shift}")
        val = val.get(attr, &on_change)  unless attr.empty
        val
      end
    end

    # FIXME: race-condition between get and watch
    watch(*attrs, &on_change)  if on_change

    vals.size > 1 ? vals : vals.first
  end

  def set(attrs = {})
    # TODO
  end

protected
  def get_one(prop, &on_change)
    set = (@_watch_props[prop.to_s] ||= Set.new)
    set << on_change
  end

  module ClassMethods
  protected
    def generated_methods
      @generated_methods ||= begin
        mod = Module.new
        include(mod)
        mod
      end
    end
  end
end
