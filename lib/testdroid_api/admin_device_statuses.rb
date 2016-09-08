module TestdroidAPI
  class AdminDeviceStatuses < CloudListResource
    def initialize(uri, client)
      super uri, client, "AdminDeviceStatus"
    end
  end
  class AdminDeviceStatus < CloudResource
    def initialize(uri, client, params= {})
      super uri, client, "adminDeviceStatus", params
    end
  end
end
