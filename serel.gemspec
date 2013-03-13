Gem::Specification.new do |s|
  s.name = "serel"
  s.version = '1.1.1'
  s.authors = ["Thomas McDonald"]
  s.email = 'tom@conceptcoding.co.uk'
  s.summary = "A Ruby library for the Stack Exchange API"
  s.homepage = "http://serel.tom.is"

  s.add_dependency 'activesupport'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'vcr'
  s.add_development_dependency 'webmock'

  s.files = Dir["lib/**/*"] + ["README.md"]
end
