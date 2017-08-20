Gem::Specification.new do |s|
  s.specification_version = 3

  s.name = 'object-schema'
  s.version = '0.1.0'
  s.date = '2015-12-26'

  s.summary = "Framework for describing/defining Ruby objects"
  s.description = "Extensible inline language for describing Ruby objects, powering schema-programming awesomeness."
  s.homepage = 'https://github.com/CodeMonkeySteve/object_schema'
  s.email = 'steve@finagle.org'
  s.authors = ["Steve Sloan"]

  s.files = [
    'MIT-LICENSE',
    'README.md',
  ] + Dir['lib/**/*']
  s.test_files = Dir['spec/**/*']

  #s.extra_rdoc_files = ['README.rdoc']
  s.rdoc_options = ['--charset=UTF-8']

  #s.platform = Gem::Platform::RUBY
  #s.rubygems_version = '1.3.7'

  s.add_dependency 'activesupport'

  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec'
end


