module TestdroidAPI
  class Admin < CloudResource
    def initialize(uri, client, params= {})
      super uri, client, "admin", params
      @uri, @client = uri, client
    end

    def device_statuses
      DeviceStatuses.new(@uri+"/device/statuses", @client)
    end

  end
end
