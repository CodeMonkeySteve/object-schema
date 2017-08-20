class ObjectSchema::Boolean < ObjectSchema::Schema
  type :boolean
end

TrueClass::Schema = FalseClass::Schema = ObjectSchema::Boolean
