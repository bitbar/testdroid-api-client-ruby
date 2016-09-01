module TestdroidAPI
  class Devices < CloudListResource
    def statuses(params = {})
      @client.get("#{@uri}/statuses", params)
    end
  end
  class Device < CloudResource
    def initialize(uri, client, params= {})
      super uri, client, "device", params
      @uri, @client = uri, client
    end
  end
end
