class Numeric::Schema < ObjectSchema::Schema
  type :number
  schema_accessor :minimum, :maximum
  alias :min :minimum
  alias :max :maximum

  def as_json(**opts)
    super.update(
      minimum: minimum,
      maximum: maximum,
    ).compact.as_json(**opts)
  end
end

class Integer::Schema < Numeric::Schema
  type :integer
end
