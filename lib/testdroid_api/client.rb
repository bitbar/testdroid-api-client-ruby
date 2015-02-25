module TestdroidAPI

	class Client
		attr_reader :config
		attr_accessor :logger
		attr_reader :token

		API_VERSION = 'api/v2'
		CLOUD_ENDPOINT='https://cloud.testdroid.com'
		ACCEPT_HEADERS={'Accept' => 'application/json'}

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
		def authorize

			@client = OAuth2::Client.new('testdroid-cloud-api', nil, :site => @cloud_url, :authorize_url    => 'oauth/authorize',
			:token_url        => 'oauth/token',  :headers => ACCEPT_HEADERS)  do |faraday|
				faraday.request  :multipart
				faraday.request  :url_encoded
				faraday.response :logger, @logger
				faraday.adapter  Faraday.default_adapter
			end

			@token = @client.password.get_token(@username, @password, :headers => ACCEPT_HEADERS)

			if (@cloud_user.nil?)
				@cloud_user = TestdroidAPI::User.new( "/#{API_VERSION}/me", self ).refresh
				@cloud_user = TestdroidAPI::User.new( "/#{API_VERSION}/users/#{@cloud_user.id}", self ).refresh

			end
			@cloud_user
		end
		def upload(uri, filename, file_type)
			begin
				@token = @token.refresh!(:headers => ACCEPT_HEADERS) if @token.expired?
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
		def post(uri, params)

			@token = @token.refresh!(:headers => ACCEPT_HEADERS) if  @token.expired?

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
		def get(uri, params={})

			@token = @token.refresh!(:headers => ACCEPT_HEADERS) if  @token.expired?

			begin
				resp = @token.get(@cloud_url+"#{uri}", params.merge(:headers => ACCEPT_HEADERS))
			rescue => e
				@logger.error "Failed to get resource #{uri} #{e}"
				return nil
			end
			JSON.parse(resp.body)
		end
		def delete(uri)

			@token = @token.refresh!(:headers => ACCEPT_HEADERS) if  @token.expired?

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
	end
end
