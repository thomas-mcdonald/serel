path = File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(path) unless $LOAD_PATH.include?(path)

#load env variables
begin
  require 'dotenv'
  Dotenv.load
rescue LoadError
  puts "dotenv not loaded."
end

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
  c.filter_sensitive_data("<STACKAPPS_API_KEY>") { ENV['STACKAPPS_API_KEY'] }
end

def configure(site = :gaming)
  # Our test configuration
  Serel::Base.config(site, ENV['STACKAPPS_API_KEY'])
  Serel::Base.logger.level = Logger::WARN
end

def new_relation(type)
  Serel::Relation.new(type, :plural)
end
