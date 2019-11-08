module TestdroidAPI

  class Client
    attr_reader :config
    attr_accessor :logger
    attr_reader :token

    API_VERSION = 'api/v2'
    CLOUD_ENDPOINT = 'https://cloud.bitbar.com'

    def initialize(username, password, cloud_url = CLOUD_ENDPOINT, logger = nil)
      # Instance variables
      @username = username
      @password = password
      @cloud_url = cloud_url
      @logger = logger

      if @logger.nil?
        @logger = Logger.new(STDOUT)
        @logger.info("Logger is not defined => output to STDOUT")
      end
    end

    def authorize
      @client = OAuth2::Client.new(
          'testdroid-cloud-api', nil, :site => @cloud_url, :token_url => 'oauth/token') do |faraday|
        faraday.request :multipart
        faraday.request :url_encoded
        faraday.response :logger, @logger
        faraday.adapter Faraday.default_adapter
      end

      @token = @client.password.get_token(@username, @password)

      if @cloud_user.nil?
        @cloud_user = TestdroidAPI::User.new("/#{API_VERSION}/me", self).refresh
        @cloud_user = TestdroidAPI::User.new("/#{API_VERSION}/users/#{@cloud_user.id}", self).refresh

      end
      @cloud_user
    end

    def mime_for(path)
      mime = MIME::Types.type_for path
      mime.empty? ? 'text/plain' : mime[0].content_type
    end

    def upload(uri, filename)
      begin
        @token = @token.refresh! if @token.expired?
        connection = @token.client.connection
        payload = {:file => Faraday::UploadIO.new(filename, mime_for(filename))}
        response = connection.post(@cloud_url + "#{uri}", payload, @token.headers)
      rescue => e
        @logger.error e
        return nil
      end
      JSON.parse(response.body)
    end

    def post(uri, params = {})

      @token = @token.refresh! if @token.expired?

      begin
        resp = @token.post("#{@cloud_url}#{uri}", params)
      rescue => e
        @logger.error "Failed to post resource #{uri} #{e}"
        return nil
      end

      if resp.body.nil? || resp.body.length == 0
        return nil
      end

      JSON.parse(resp.body)
    end

    def get(uri, params = {})

      @token = @token.refresh! if @token.expired?

      begin
        resp = @token.get(@cloud_url + "#{uri}", :params => params)
      rescue => e
        @logger.error "Failed to get resource #{uri} #{e}"
        return nil
      end
      JSON.parse(resp.body)
    end

    def delete(uri)

      @token = @token.refresh! if @token.expired?

      begin
        resp = @token.delete(@cloud_url + "#{uri}")
      rescue => e
        @logger.error "Failed to delete resource #{uri} #{e}"
        return nil
      end

      if resp.status != 204
        @logger.error "Failed to delete resource #{uri} #{e}"
      else
        @logger.info "response: #{resp.status}"
      end
    end

    def download(uri, file_name)
      begin
        @token = @token.refresh! if @token.expired?
        ::File.open(file_name, "w+b") do |file|
          full_uri = uri.start_with?(@cloud_url) ? uri : @cloud_url + uri
          resp = @token.get(full_uri)
          file.write(resp.body)
        end
      rescue => e
        @logger.error "Failed to get resource #{uri} #{e}"
        return nil
      end
    end

# Resources

# public read-only

    def info
      TestdroidAPI::CloudResource.new("/#{API_VERSION}/info", self, "info")
    end

    def devices
      TestdroidAPI::Devices.new("/#{API_VERSION}/devices", self)
    end

    def label_groups
      TestdroidAPI::LabelGroups.new("/#{API_VERSION}/label-groups", self)
    end

# user read-write

    def me
      TestdroidAPI::User.new("/#{API_VERSION}/me", self).load
    end

    def properties
      TestdroidAPI::Properties.new("/#{API_VERSION}/properties", self)
    end

    def device_session_connections
      TestdroidAPI::DeviceSessionConnections.new("/#{API_VERSION}/device-session-connections", self)
    end

# admin only

    def admin
      TestdroidAPI::Admin.new("/#{API_VERSION}/admin", self)
    end

  end
end
