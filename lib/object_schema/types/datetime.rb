#require 'object_schema/string'
require 'date'

class DateTime::Schema < String::Schema
  def initialize
    form :date_time
  end
end

class Time::Schema < String::Schema
  type :number

  def initialize
    form :utc_millisec
  end
end

class Date::Schema < String::Schema
  def initialize
    form :date
  end
end
