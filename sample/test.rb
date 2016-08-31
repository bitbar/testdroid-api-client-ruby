require 'testdroid-api-client'

client = TestdroidAPI::Client.new('8V5vhVGjWVyT2ECQGFFTvV6nQdYuIUQ5', 'https://integration.testdroid.com')

puts client.get("me")
