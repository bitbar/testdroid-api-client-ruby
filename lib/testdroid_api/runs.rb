module TestdroidAPI
  class Runs < CloudListResource

    def create(data = {})
      super :body => data, :headers => {'Content-Type' => 'application/json'}
    end

  end
  class Run < CloudResource
    def initialize(uri, client, params = {})
      if params.key?('projectId') and ! uri.include?("projects")
        uri.sub! 'runs', "projects/#{params['projectId']}/runs"
      end
      super uri, client, "run", params
      @uri, @client = uri, client
      sub_items :device_sessions
    end

    def abort()
      @client.post("#{@uri}/abort", params = {})
    end

  end
end
