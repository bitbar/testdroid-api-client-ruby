
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
			DeviceSession.new("#{@uri}", @client, resp)
		end
	end
end
