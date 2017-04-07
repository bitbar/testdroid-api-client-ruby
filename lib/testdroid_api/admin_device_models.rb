module TestdroidAPI
  class AdminDeviceModels < CloudListResource
  end
  class AdminDeviceModel < CloudResource
    def initialize(uri, client, params= {})
      super uri, client, "adminDeviceModel", params
      @uri, @client = uri, client
    end
  end
end
