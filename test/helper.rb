require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'test/unit'
require 'shoulda'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'vcr'
require 'webmock'

WebMock.disable_net_connect!

VCR.config do |config|
  config.cassette_library_dir = 'test/fixtures/vcr_cassettes'
  config.stub_with :webmock
  config.default_cassette_options = { :record => :none }
end

require 'baby_tooth'

class Test::Unit::TestCase
end
