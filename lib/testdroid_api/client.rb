module TestdroidAPI

  class Client
    attr_reader :config
    attr_accessor :logger

    API_VERSION = 'api/v2'
    CLOUD_ENDPOINT = 'https://cloud.testdroid.com'
    ACCEPT_HEADERS = {'Accept' => 'application/json'}

    def initialize(api_key, cloud_url = CLOUD_ENDPOINT, logger = nil)
      # Instance variables
      @api_key = api_key
      @cloud_url = cloud_url
      @logger = logger

      if @logger.nil?
        @logger = Logger.new(STDOUT)
        @logger.info("Logger is not defined => output to STDOUT")
      end
    end

    # Basic methods

    def request_factory(method, uri, http_params = {})
      default_http_params = {
          :method => method,
          :url => uri,
          :user => @api_key,
          :password => "",
          :headers => ACCEPT_HEADERS
      }
      request_http_params = default_http_params.deep_merge!(http_params)

      RestClient::Request.new(request_http_params)
    end

    def get(uri, params={}, http_params={})
      uri = @cloud_url+uri
      begin
        http_params = http_params.deep_merge({ :headers => {:params => params} })
        request = self.request_factory(:get, uri, http_params)
        resp = request.execute
      rescue => e
        @logger.error "Failed to get resource #{uri} #{e}"
        return nil
      end
      JSON.parse(resp.body)
    end

    def post(uri, params={}, http_params={})
      uri = @cloud_url+uri
      begin
        http_params = http_params.deep_merge({ :payload => params })
        request = self.request_factory(:post, uri, http_params)
        resp = request.execute
      rescue => e
        @logger.error "Failed to post resource #{uri} #{e}"
        return nil
      end

      if resp.body.nil? || resp.body.length == 0
        return nil
      end

      JSON.parse(resp.body)
    end

    def delete(uri)
      uri = @cloud_url+uri
      begin
        request = self.request_factory(:delete, uri)
        resp = request.execute
      rescue => e
        @logger.error "Failed to delete resource #{uri} #{e}"
        return nil
      end

      if (resp.status != 204)
        @logger.error "Failed to delete resource #{uri} #{e}"
        return nil
      else
        @logger.info "response: #{resp.status}"
      end
    end

    def upload(uri, file_name)
      self.post(uri, {
          :multipart => true,
          :file => File.new(file_name, 'rb')
      })
    end

    def download(uri, file_name, params={}, http_params={})
      begin
        File.open(file_name, "w+b") do |file|
          http_params = http_params.deep_merge({ :headers => {:params => params} })
          request = self.request_factory(:get, @cloud_url+"#{uri}", http_params)
          resp = request.execute
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
