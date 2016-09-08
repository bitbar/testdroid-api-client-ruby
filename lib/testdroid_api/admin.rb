module TestdroidAPI
  class Admin < CloudResource
    def initialize(uri, client, params= {})
      super uri, client, "admin", params
      @uri, @client = uri, client
    end

    def device_statuses
      AdminDeviceStatuses.new(@uri+"/device/statuses", @client)
    end

    def device_problems
      AdminDeviceProblems.new(@uri+"/device-problems", @client)
    end

    def device_models
      AdminDeviceModels.new(@uri+"/device-models", @client)
    end

    def devices
      AdminDevices.new(@uri+"/devices", @client)
    end

  end
end
