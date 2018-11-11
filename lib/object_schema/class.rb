module ObjectSchema
  module Class
    def self.included(base)
      base.const_set('Schema', ::Class::Schema)  unless base.const_defined?('Schema')
      base.extend ClassMethods
    end

    def _schema
      self.class.schema
    end

    module ClassMethods
      def schema(&defn)
        if @_schema
          raise "Attempt to reopen #{self.inspect} schema"  if defn
          return @_schema
        end
        @_schema = const_get('Schema').new(&defn)

        # if const_defined?('Schema', !:inherited)
        #   klass = const_get('Schema')
        # else
        #   klass = self.class.const_get('Schema')
        #   const_set('Schema', klass)
        # end
        #
        # @_schema = klass.new(&defn)
      end
    end
  end
end
