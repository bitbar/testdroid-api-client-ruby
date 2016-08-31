module TestdroidAPI

	class Client
		attr_reader :config
		attr_accessor :logger

		API_VERSION = 'api/v2'
		CLOUD_ENDPOINT = 'https://cloud.testdroid.com'
		ACCEPT_HEADERS = { 'Accept' => 'application/json' }

		def initialize(api_key, cloud_url = CLOUD_ENDPOINT, logger = nil)
			# Instance variables
			@api_key = api_key
			@cloud_url = cloud_url + "/" + API_VERSION + "/"
			@logger = logger

			if @logger.nil?
				@logger = Logger.new(STDOUT)
				@logger.info("Logger is not defined => output to STDOUT")
			end
		end
        
        # Basic methods
        
        def request_factory(method, uri, params)
            default_params =
                :method => method,
                :url => uri,
                :user => @api_key,
                :password => "",
                :headers => ACCEPT_HEADERS
                
            request_params = default_params.deep_merge!(params)
        
            RestClient::Request.new(request_params)      
        end
        
		def get(uri, params={})
			begin
				request = self.request_factory(:get, @cloud_url+"#{uri}", params)
                resp = request.execute
                
			rescue => e
				@logger.error "Failed to get resource #{uri} #{e}"
				return nil
			end
			JSON.parse(resp.body)
		end
        
		def post(uri, params)

			begin
				resp = @token.post("#{@cloud_url}#{uri}", params.merge(:headers => ACCEPT_HEADERS))
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

			begin
				resp = @token.delete(@cloud_url+"#{uri}",  :headers => ACCEPT_HEADERS )
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
        
		def upload(uri, filename, file_type)
			begin
				connection = @token.client.connection
				payload = {:file  => Faraday::UploadIO.new(filename, file_type) }
				headers = ACCEPT_HEADERS.merge(@token.headers)
				response = connection.post(@cloud_url+"#{uri}",payload, headers)
			rescue => e
				@logger.error e
				return nil
			end
			JSON.parse(response.body)
		end
        
		def download(uri, file_name)
			begin
				@token = @token.refresh!(:headers => ACCEPT_HEADERS) if  @token.expired?
				File.open(file_name, "w+b") do |file|
					resp = @token.get("#{@cloud_url}/#{uri}", :headers => ACCEPT_HEADERS)
					file.write(resp.body)
				end
			rescue => e
				@logger.error "Failed to get resource #{uri} #{e}"
				return nil
			end
		end
        
        # Public API resources
        
		def label_groups
			label_groups = TestdroidAPI::LabelGroups.new( "/#{API_VERSION}/label-groups", self )
			label_groups.list
			label_groups
		end
        
		def devices
			devices = TestdroidAPI::Devices.new( "/#{API_VERSION}/devices", self )
			devices.list
			devices
		end
        
	end
end
