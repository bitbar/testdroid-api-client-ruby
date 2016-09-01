module TestdroidAPI
  class Devices < CloudListResource
  end
  class Device < CloudResource
    def initialize(uri, client, params= {})
      super uri, client, "device", params
      @uri, @client = uri, client

    end

  end
end
