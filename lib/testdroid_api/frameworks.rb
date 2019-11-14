module TestdroidAPI
  class Frameworks < CloudListResource
  end
  class Framework < CloudResource
    def initialize(uri, client, params = {})
      super uri, client, "Framework", params
      @uri, @client = uri, client
    end

  end
end
