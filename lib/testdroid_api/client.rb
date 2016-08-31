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
			begin
                http_params = http_params.deep_merge({
                    :headers => { :params => params }
                })
				request = self.request_factory(:get, @cloud_url+"#{uri}", http_params)
                resp = request.execute
			rescue => e
				@logger.error "Failed to get resource #{uri} #{e}"
				return nil
			end
			JSON.parse(resp.body)
		end
        
		def post(uri, params={}, http_params={})
			begin
                http_params = http_params.deep_merge({
                    :payload => params
                })
				request = self.request_factory(:post, @cloud_url+"#{uri}", http_params)
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

			begin
				request = self.request_factory(:delete, @cloud_url+"#{uri}")
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
                    http_params = http_params.deep_merge({
                        :headers => { :params => params }
                    })
                    request = self.request_factory(:get, @cloud_url+"#{uri}", http_params)
                    resp = request.execute
					file.write(resp.body)
				end
			rescue => e
				@logger.error "Failed to get resource #{uri} #{e}"
				return nil
			end
		end
        
        # User-only API resources
        
        def me
            TestdroidAPI::User.new( "/#{API_VERSION}/me", self ).refresh
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
