require 'active_support/dependencies/autoload'
require 'active_support/core_ext/object/blank'
require 'active_support/core_ext/object/json'
require 'active_support/json/encoding'
require 'active_support/callbacks'

module ObjectSchema
  class Schema
    extend ActiveSupport::Autoload
    include ActiveSupport::Callbacks
    define_callbacks :defined

    autoload :Boolean
    autoload :Object
    autoload :Property

  protected

    def self.schema_reader(*attrs)
      attrs.each do |attr|
        self.class_eval "def #{attr}(*args, &blk); args.empty? ? @#{attr} : self.__send__(\"#{attr}=\".to_sym, *args, &blk) ; end"
      end
    end
    def self.schema_accessor(*attrs)
      schema_reader(*attrs)
      attrs.each do |attr|
        self.class_eval "def #{attr}=(val); @#{attr} = val ; end"
      end
    end

  public

    Types = %i{string number integer boolean object array function null any}.freeze
    def self.type(type = nil)
      if type
        type = type.to_sym
        raise ArgumentError, "Unknown type: #{type.inspect}"  unless Types.include?(type)
        @type = type.to_sym
      end
      @type || self.superclass.type
    end

    def initialize(&defn)
      run_callbacks(:defined) { instance_eval(&defn) }  if defn
    end

    schema_reader :name
    def name=(str)
      @name = str.to_s
    end

    schema_reader :description
    def description=(str)
      @description = str.to_s
    end
    alias :desc :description

    def as_json(**opts)
      {
        type: self.class.type.to_s,
        title: name,
        description: description
      }.reject { |_, v|  v.blank? }.as_json(**opts)
    end

    def to_json(opts = {})
      self.as_json(opts).to_json
    end

    def self.instantiate(schema)
      if !schema || schema.is_a?(ObjectSchema::Schema)
        schema

      elsif schema.is_a?(Array)
        Array::Schema.new(*schema)

      elsif schema <= ObjectSchema::Schema  # schema.is_a?(Class)
        schema.new

      elsif schema.respond_to?(:schema) && schema.schema
        schema.schema.dup

      elsif schema.respond_to?(:const_defined?) && schema.const_defined?('Schema')
        schema.const_get('Schema').new

      else
        raise "Can't instantiate schema #{schema.inspect}"
      end
    end

  protected
    def normalize_opts(name_or_schema, schema)
      name = if schema
        name_or_schema
      elsif name_or_schema.is_a?(String) || name_or_schema.is_a?(Symbol)
       name_or_schema.to_s
      else
       schema = name_or_schema
       nil
      end

      [ name, schema ]
    end
  end
end