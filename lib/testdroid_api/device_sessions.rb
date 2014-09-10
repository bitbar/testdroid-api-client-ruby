
module TestdroidAPI
		class DeviceSessions < CloudListResource
		end
		class DeviceSession < CloudResource
			def	initialize(uri, client, params= {})
				super uri, client,"deviceSession", params
				@uri, @client = uri, client
			end  
		end
end
