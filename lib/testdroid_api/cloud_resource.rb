
module TestdroidAPI
	class CloudResource
		def initialize(uri, client,  resource_name=nil, params= {})

			@uri, @client, @resource_name = uri, client, resource_name
			set_up_properties_from( params )
		end
		def inspect # :nodoc:
			"<#{self.class} @uri=#{@uri}>"
		end
		def sub_items(*items)
			items.each do |item|
				resource = camel_case_it item
				uri = "#{@uri}/#{item.to_s.gsub('_', '-') }"
				resource_class = TestdroidAPI.const_get resource
				new_class = resource_class.new(uri, @client)
				instance_variable_set( "@#{item}", new_class )
			end
			self.class.instance_eval {attr_reader *items}
		end
		def method_missing(method, *args)
			super if @updated
			set_up_properties_from(@client.get(@uri))
			self.send method, *args
		end
		def update(params = {})
        	raise "Can't update a resource without a REST Client" unless @client
        	set_up_properties_from(@client.post(@uri, params))
        	self
      	end
		def set_up_properties_from(hash)

			eigenclass = class << self; self; end
			hash.each do |p,v|
				property = snake_case_it p

				unless ['uri', 'client', 'updated'].include? property
					eigenclass.send :define_method, property.to_sym, &lambda {v}
				end
			end
			@updated = !hash.keys.empty?
		end

		def refresh
			raise "Can't refresh a resource without a REST Client" unless @client
			@updated = false
			set_up_properties_from(@client.get(@uri))
			self
		end
		def download_file(file_resource_name, target_file_name=nil)
			raise "Can't refresh a resource without a REST Client" unless @client
			target_file_name = file_resource_name unless target_file_name
			@client.download("#{@uri}/#{file_resource_name}", target_file_name)
		end
		def camel_case_it(something)
			if something.is_a? Hash
				Hash[*something.to_a.map {|a| [camel_case_it(a[0]).to_sym, a[1]]}.flatten]
			else
				something.to_s.split('_').map do |s|
					[s[0,1].capitalize, s[1..-1]].join
				end.join
			end
		end
		def snake_case_it(something)
			if something.is_a? Hash
				Hash[*something.to_a.map {|pair| [snake_case_it(pair[0]).to_sym, pair[1]]}.flatten]
			else
				something.to_s.gsub(/[A-Z][a-z]*/) {|s| "_#{s.downcase}"}.gsub(/^_/, '')
			end
		end
		def delete
			raise "Can't delete a resource without a REST Client" unless @client
			client.delete(@uri)
		end
	end
end
