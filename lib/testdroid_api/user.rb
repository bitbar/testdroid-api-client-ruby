module TestdroidAPI
  class User < CloudResource
    def initialize(uri, client, params = {})
      super uri, client, "users", params
      sub_items :projects, :device_groups, :device_sessions, :files, :runs
    end

    def available_frameworks
      Frameworks.new(@uri + "/available-frameworks", @client)
    end

  end
end
