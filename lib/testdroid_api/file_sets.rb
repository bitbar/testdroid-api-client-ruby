
module TestdroidAPI
	class Files < CloudResource
		def	initialize(uri, client, params= {})

			super uri, client,"fileSets", params
			@uri, @client = uri, client

		end

	end
end
