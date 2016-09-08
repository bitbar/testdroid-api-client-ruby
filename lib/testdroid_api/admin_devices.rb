module TestdroidAPI
  class AdminDevices < CloudListResource
  end
  class AdminDevice < CloudResource
    def initialize(uri, client, params= {})
      super uri, client, "adminDevice", params
      @uri, @client = uri, client
    end
  end
end
