module TestdroidAPI
  class DeviceSessions < CloudListResource
  end
  class DeviceSession < CloudResource
    def initialize(uri, client, params = {})
      super uri, client, "deviceSession", params
      @uri, @client = uri, client
    end

    def release
      @client.post("#{@uri}/release", params = {})
    end

    def download_all_files(path)
      Dir.mkdir(path) unless Dir.exist?(path)
      files = @client.get("#{@uri}/output-file-set/files")
      files['data'].each do |file|
        @client.download(file['directUrl'], ::File.join(path, "#{file['id']}-#{file['name']}"))
      end
    end

  end
end
