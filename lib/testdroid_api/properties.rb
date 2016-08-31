
module TestdroidAPI
	class Properties < CloudListResource
		def initialize(uri, client)
			super uri, client, "Property"
		end
	end
	class Property < CloudResource
		def	initialize(uri, client, params= {})
			super uri, client, "property", params
		end

	end
end
