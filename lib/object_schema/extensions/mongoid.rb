require 'object_schema/schema'

module ObjectSchema::Mongoid
  module Document
    def included( mod )
      mod.include ::Mongoid::Document
      schema = mod.schema

      for property in schema.properties
        #mod.field
      end
    end
  end
end

