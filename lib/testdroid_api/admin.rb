module TestdroidAPI
  class Admin < CloudResource
    def initialize(uri, client, params= {})
      super uri, client, "admin", params
      @uri, @client = uri, client
    end

    def devices(params = {})
      Devices.new(@uri+"/devices", @client)
    end

  end
end
