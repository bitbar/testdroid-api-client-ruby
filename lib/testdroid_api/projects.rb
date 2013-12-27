
module TestdroidAPI
		class Projects < CloudListResource
		end
		
		class Project < CloudResource
		
			def	initialize(uri, client, params= {})
				super uri, client,"project", params
				@uri, @client = uri, client
				sub_items :runs, :files
			end
			def run(name=nil)
				run_parameters = name.nil? ? {:params => {}} : {:params =>  {'name' => name} }

				resp = @client.post("#{@uri}/runs", run_parameters)
				Run.new("#{@uri}/runs/#{resp['id']}", @client, resp)
				
			end
			
		end
end
