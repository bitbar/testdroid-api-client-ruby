module TestdroidAPI
  class DeviceSessionConnections < CloudListResource
  end
  class DeviceSessionConnection < CloudResource
    def initialize(uri, client, params = {})
      super uri, client, "DeviceSessionConnection", params
      @uri, @client = uri, client
    end
  end
end
