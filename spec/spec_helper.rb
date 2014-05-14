gem 'rspec', '~> 2.4'
gem 'faraday', '~> 0.9'

require 'rspec'
require 'json'
require_relative '../lib/testdroid-api-client'
require 'webmock/rspec'
require 'vcr'

include TestdroidAPI
CLOUD_ENDPOINT='https://cloud.testdroid.com'


VCR.configure do |c|
  c.cassette_library_dir = File.join(File.dirname(__FILE__), 'fixtures', 'cassettes')
  c.hook_into :webmock , :faraday
  c.default_cassette_options = {:serialize_with => :json,    :preserve_exact_body_bytes => true, :decode_compressed_response => true}
  c.allow_http_connections_when_no_cassette = false
end

def client 
	@client ||= begin
		client = Client.new('defaultuser', 'password')
	rescue Exception => e
	end
end
