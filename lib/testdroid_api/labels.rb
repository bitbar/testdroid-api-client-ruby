module TestdroidAPI
  class Labels < CloudListResource
  end
  class Label < CloudResource
    def initialize(uri, client, params = {})
      super uri, client, "label", params
      @uri, @client = uri, client
      sub_items :devices
    end

  end
end
