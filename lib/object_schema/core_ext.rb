#require 'object_schema/schema'

# class Regexp
#   def as_json(opts = {})
#     self.source.as_json
# #     io << 'i'  if (options & ::Regexp::IGNORECASE) != 0
# #     io << 'ms' if (options & ::Regexp::MULTILINE) != 0
# #     io << 'x'  if (options & ::Regexp::EXTENDED) != 0
#   end
# end

Object.class_eval do
  include ObjectSchema::Object
end
