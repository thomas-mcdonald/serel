path = File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(path) unless $LOAD_PATH.include?(path)

# Test helpers
require 'vcr'

require 'serel'

RSpec.configure do |c|
  # Make sure the api_key/site is set correctly
  c.before(:each) { configure }
end

VCR.configure do |c|
  c.cassette_library_dir = 'spec/cassettes'
  c.hook_into :webmock
end

def configure
  # Our test configuration
  Serel::Base.config(:gaming, '0p65aJUHxHo0G19*YF272A((')
end

def new_relation(type)
  Serel::Relation.new(type, :plural)
end