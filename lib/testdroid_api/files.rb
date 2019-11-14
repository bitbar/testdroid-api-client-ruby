module TestdroidAPI
  class Files < CloudListResource

    def upload(filename)
      unless ::File.exist?(filename)
        @client.logger.error("Invalid filename")
        return
      end
      file = @client.upload("#{@uri}", filename)
      File.new("#{@uri}/#{file['id']}", @client, file)
    end

  end
  class File < CloudResource
    def initialize(uri, client, params = {})
      super uri, client, "file", params
      @uri, @client = uri, client
    end
  end
end
