require 'object_schema/types/string'

module ObjectSchema
  module Buildable
    extend ActiveSupport::Concern

    # included do
    #   #include ActiveSupport::Callbacks
    #   #define_callbacks :defined
    # end

    def initialize(parent: nil, schema: nil, &defn)
      @_parent = parent
      self.schema = Schema.instantiate(schema)  if schema
      self.instance_eval(&defn)  if defn
      #run_callbacks(:defined) { self.instance_eval(&defn) }  if defn
    end

    def method_missing(method, *args, &blk)
      schema.__send__(method, *args, &blk)
    end

    def respond_to_missing?(method, include_private = false)
      (@schema && @schema.respond_to?(method)) || super
    end

    def schema
      self.schema = String::Schema.new  unless @schema
      @schema
    end

    def schema=(schema)
      @schema = schema
    end
    protected :schema=

    module ClassMethods
      def build_methods(*methods)
        schema = self
        methods.each do |method|
          ObjectSchema::Buildable.send(:define_method, method) do |*args, &defn|
            self.schema = Schema.instantiate(schema)  unless @schema
            @schema.send(method, *args, &defn)
          end
        end
      end
    end
  end

  class Builder
    include ObjectSchema::Buildable
  end
end
