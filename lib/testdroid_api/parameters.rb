
module TestdroidAPI
	class Parameters < CloudListResource
	end
	class Parameter < CloudResource
		def	initialize(uri, client, params= {})
			super uri, client,"parameter", params
		end

	end
end
