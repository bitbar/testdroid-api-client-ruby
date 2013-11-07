
module TestdroidAPI
		class Files < CloudResource
			def	initialize(uri, client, params= {})
				
				super uri, client,"files", params
				@uri, @client = uri, client
				
			end
		end
		def uploadAPK(filename)
				if !File.exist?(filename) 
					@client.logger.error( "Invalid filename")
					return
				end
				reply = @client.upload("#{@uri}/application", filename, "application/vnd.android.package-archive")
				AndroidApp.new(nil, nil, reply)
		end
		class AndroidApp < CloudResource
			def	initialize(uri, client, params= {})
				super uri, client,"app", params
				@uri, @client = uri, client
				
			end
		end
		class AndroidTest < CloudResource
			def	initialize(uri, client, params= {})
				super uri, client,"test", params
				@uri, @client = uri, client
				
			end
		end

end
