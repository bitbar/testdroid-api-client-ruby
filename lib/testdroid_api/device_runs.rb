
module TestdroidAPI
  class DeviceRuns < CloudListResource
  end
  class DeviceRun < CloudResource
    def initialize(uri, client, params= {})
      super uri, client,"deviceRun", params
      @uri, @client = uri, client
    end
    def download_performance(file_name="performance_data.txt")
      @client.download("#{@uri}/performance", file_name)
    end
    def download_junit(file_name="junit.xml")
      @client.download("#{@uri}/junit.xml", file_name)
    end
    def download_logs(file_name="log.txt")
      @client.download("#{@uri}/logs", file_name)
    end
  end
end
