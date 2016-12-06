
module TestdroidAPI
	class DeviceGroups < CloudListResource
	end
	class DeviceGroup < CloudResource
		def	initialize(uri, client, params= {})
			super uri, client,"deviceGroup", params
			@uri, @client = uri, client
		end

    def devices
      return Devices.new("#{@uri}/devices", @client)
    end

	end
end
