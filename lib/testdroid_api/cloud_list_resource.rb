
module TestdroidAPI
	class CloudListResource

		def initialize(uri, client, instance_class=nil)
			@uri, @client = uri, client
			resource_name = self.class.name.split('::')[-1]
			@instance_class = instance_class.nil? ? TestdroidAPI.const_get resource_name.chop : instance_class 
			@list_key, @instance_id_key = resource_name.gsub!(/\b\w/) { $&.downcase } , 'id'
		end
		def get(resource_id)
			@instance_class.new( "#{@uri}/#{resource_id}", @client)
		end
		def total

			@client.get(@uri)['total']
		end
		def create(params={}, http_params={})
			raise "Can't create a resource without a REST Client" unless @client
			response = @client.post @uri, params
			@instance_class.new "#{@uri}/#{response[@instance_id_key]}", @client,
				response
		end
		def list_all()
			raise "Can't get a resource list without a REST Client" unless @client

			response = @client.get(@uri, { :limit => 0 })

			if response['data'].is_a?(Array)
				client = @client
				class_list = []
				list_class = self.class
				instance_uri =  @uri
				response['data'].each do |val|

					class_list << @instance_class.new( "#{instance_uri}/#{val[@instance_id_key]}", @client, val)
				end
			end
			class_list
		end
		def list(params={}, full_uri=false)
			raise "Can't get a resource list without a REST Client" unless @client
			@uri = full_uri ? @uri.split(@client.instance_variable_get(:@cloud_url))[1] : @uri

			response = @client.get(@uri, params)

			if response['data'].is_a?(Array)
				client = @client
				class_list = []
				list_class = self.class
				instance_uri = full_uri ? @uri.split('?')[0] : @uri
				response['data'].each do |val|

					class_list << @instance_class.new( "#{instance_uri}/#{val[@instance_id_key]}", @client, val)
				end
				class_list.instance_eval do
					eigenclass = class << self; self; end

					eigenclass.send :define_method, :offset, &lambda {response['offset']}
					eigenclass.send :define_method, :limit, &lambda {response['limit']}
					eigenclass.send :define_method, :total, &lambda {response['total']}
					eigenclass.send :define_method, :next_page, &lambda {
						if response['next']

							list_class.new(response['next'], client).list({}, true)
						else
							[]
						end
					}
					eigenclass.send :define_method, :previous_page, &lambda {
						if response['previous']

							list_class.new(response['previous'], client).list({}, true)
						else
							[]
						end
					}
				end
			end
			class_list
		end
	end
end
