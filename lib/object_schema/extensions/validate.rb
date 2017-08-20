class Schema
  def validate?( obj, errors = [] )
  end
end



class String::Schema
  def validate?( obj, errors = [] )
    false  unless super

  end
end


class Schema::Property
  def validate?( obj, errors = [] )
    return false unless super

    if @required && obj.nil?

    end
  end
end