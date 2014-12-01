gem 'rspec'
gem 'rspec-collection_matchers'
gem 'faraday', '~> 0.8.8'

require 'rspec'
require 'json'
require_relative '../lib/testdroid-api-client'
require 'webmock/rspec'
require 'vcr'

include TestdroidAPI
CLOUD_ENDPOINT='https://cloud.testdroid.com'


VCR.configure do |c|
	puts "init VCR"
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
def client_local_host 
	@client_local_host ||= begin
		client_local_host = Client.new('admin@localhost', 'admin', 'http://localhost:8080/testdroid-cloud')
	rescue Exception => e
	end
end
