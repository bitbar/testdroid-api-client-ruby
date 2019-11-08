module TestdroidAPI
  class Projects < CloudListResource
  end

  class Project < CloudResource

    def initialize(uri, client, params = {})
      super uri, client, "project", params
      @uri, @client = uri, client
      sub_items :runs
    end

  end
end
