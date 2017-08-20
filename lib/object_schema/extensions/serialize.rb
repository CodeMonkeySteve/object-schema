class Schema
  def to_hash
    OrderedHash[
      :type,       (@type.size == 1) ? @type.first : @type,
      :properties, OrderedHash[ *@properties.map { |k, v|  [k.to_s, v.to_hash] }.flatten ],
      :items,      @items,
# TODO
    ]
  end

  def to_json
    to_hash.to_json
  end
end