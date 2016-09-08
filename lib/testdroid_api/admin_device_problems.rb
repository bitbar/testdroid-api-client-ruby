module TestdroidAPI
  class AdminDeviceProblems < CloudListResource
  end
  class AdminDeviceProblem < CloudResource
    def initialize(uri, client, params= {})
      super uri, client, "adminDeviceProblem", params
    end
  end
end
