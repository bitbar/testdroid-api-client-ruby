module TestdroidAPI
	class Runs < CloudListResource
	end
	class Run < CloudResource
		def	initialize(uri, client, params= {})
			super uri, client,"run", params
			@uri, @client = uri, client
			sub_items :device_runs
		end
		def abort()
      		@client.post("#{@uri}/abort", params= {})
	    end
	end
end
