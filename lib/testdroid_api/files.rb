module TestdroidAPI
  class Files < CloudResource
    def initialize(uri, client, params= {})
      super uri, client, "files", params
      @uri, @client = uri, client
    end

    def uploadApplication(filename, mime_type = "application/vnd.android.package-archive")
      if !File.exist?(filename)
        @client.logger.error("Invalid filename")
        return
      end
      reply = @client.upload("#{@uri}/application", filename)

      Application.new(nil, nil, reply)
    end

    def uploadData(filename, mime_type = "application/zip")
      if !File.exist?(filename)
        @client.logger.error("Invalid filename")
        return
      end
      reply = @client.upload("#{@uri}/data", filename)

      Data.new(nil, nil, reply)
    end

    def uploadTest(filename, mime_type = "application/vnd.android.package-archive")
      if !File.exist?(filename)
        @client.logger.error("Invalid filename")
        return
      end
      reply = @client.upload("#{@uri}/test", filename)

      Test.new(nil, nil, reply)
    end
  end
  class Application < CloudResource
    def initialize(uri, client, params= {})
      super uri, client, "app", params
      @uri, @client = uri, client

    end
  end
  class Test < CloudResource
    def initialize(uri, client, params= {})
      super uri, client, "test", params
      @uri, @client = uri, client

    end
  end
  class Data < CloudResource
    def initialize(uri, client, params= {})
      super uri, client, "data", params
      @uri, @client = uri, client

    end
  end
end
