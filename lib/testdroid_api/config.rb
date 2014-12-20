module TestdroidAPI
	class Config < CloudResource
		def initialize(uri, client, params={})
			super uri, client,"config", params
		end
	end
end
