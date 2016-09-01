module TestdroidAPI
  class DeviceStatuses < CloudListResource
    def initialize(uri, client)
      super uri, client, "DeviceStatus"
    end
  end
  class DeviceStatus < CloudResource
    def initialize(uri, client, params= {})
      super uri, client, "deviceStatus", params
    end

  end
end
