require 'object_schema/schema'

class String::Schema < ObjectSchema::Schema
  type :string
  Formats = %w{attachment date_time date time utc_millisec regex color style phone uri url email image image_ref image_attachment
               ip_address ipv6 urn street_address locality region postal_code country}.map(&:to_sym).freeze
               # TODO: Any valid MIME media type, URL to a definition

  schema_accessor :min_length
  schema_accessor :max_length

  def pattern(*args)
    return @pattern  if args.empty?
    pattern = args[0]
    raise ArgumentError, "Expected Regexp: #{pattern.inspect}" unless pattern.kind_of?(Regexp)
    @pattern = pattern
  end
  alias_method :pattern=, :pattern

  def form(*args)
    return @format  if args.empty?
    format = args[0]
    #requires_type :string  unless format == :utc_millisec
    raise ArgumentError, "Unknown format #{format.inspect}"  unless Formats.include?(format)
    # TODO
    @format = format
  end
  alias_method :form=, :form

  def as_json(**opts)
    super.update(
      minLength: min_length&.to_i,
      maxLength: max_length&.to_i,
      pattern: pattern&.as_json,
      format: form&.to_s,
    ).compact.as_json(**opts)
  end
end
