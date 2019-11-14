module TestdroidAPI
  class Services < CloudListResource
  end
  class Service < CloudResource
    def initialize(uri, client, params = {})
      super uri, client, "service", params
    end

    def get_available
      @client.get("#{@uri}/available")
    end

    def get_purchased
      @client.get("#{@uri}/purchased")
    end

  end
end
