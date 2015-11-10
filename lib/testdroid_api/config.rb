module TestdroidAPI
	class Config < CloudResource
		def initialize(uri, client, params={})
			super uri, client,"config", params
			@uri, @client = uri, client
			sub_items :parameters
		end
	end
end
