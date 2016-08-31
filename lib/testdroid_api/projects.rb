
module TestdroidAPI
    class Projects < CloudListResource
    end

    class Project < CloudResource

         def initialize(uri, client, params= {})
            super uri, client,"project", params
            @uri, @client = uri, client
            sub_items :runs, :files, :config
        end
        
        def run(run_parameters = {})
            resp = @client.post("#{@uri}/runs", run_parameters)
            Run.new("#{@uri}/runs/#{resp['id']}", @client, resp)
        end

    end
end
