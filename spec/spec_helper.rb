require 'object_schema'

RSpec.configure do |config|
  # config.filter_run focus: true
  # config.run_all_when_everything_filtered = true
end

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f|  require f }
