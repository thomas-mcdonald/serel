path = File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(path) unless $LOAD_PATH.include?(path)

# Test helpers
require 'vcr'

require 'serel'

VCR.configure do |c|
  c.cassette_library_dir = 'spec/cassettes'
  c.hook_into :webmock
end

Serel::Base.config(:gaming, '0p65aJUHxHo0G19*YF272A((')