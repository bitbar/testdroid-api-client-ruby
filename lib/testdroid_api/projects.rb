
module TestdroidAPI
    class Projects < CloudListResource
    end

    class Project < CloudResource

         def initialize(uri, client, params= {})
            super uri, client,"project", params
            @uri, @client = uri, client
            sub_items :runs, :files
        end
        #Start a new test run
        #run_parameters - example {:params =>  {'name' => 'test'}} 
        def run(run_parameters={:params => {}})
            resp = @client.post("#{@uri}/runs", run_parameters)
            Run.new("#{@uri}/runs/#{resp['id']}", @client, resp)
        end

    end
end
