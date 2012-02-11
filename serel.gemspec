Gem::Specification.new do |s|
  s.name = "serel"
  s.version = '0.0.1'
  s.authors = ["Thomas McDonald"]
  s.email = 'tom@conceptcoding.co.uk'
  s.summary = "An AREL-like library for the Stack Exchange API"
  s.homepage = "http://github.com/thomas-mcdonald/serel"

  s.add_development_dependency 'rspec'

  s.files = Dir["lib/**/*"] + ["README.md"]
end