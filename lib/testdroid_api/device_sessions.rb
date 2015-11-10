
module TestdroidAPI
	class DeviceSessions < CloudListResource
	end
	class DeviceSession < CloudResource
		def	initialize(uri, client, params= {})
			super uri, client,"deviceSession", params
			@uri, @client = uri, client
		end
		def release
			resp = @client.post("#{@uri}/release", params= {})
		end
	end
end
