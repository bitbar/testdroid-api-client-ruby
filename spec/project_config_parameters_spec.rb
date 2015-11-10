require 'spec_helper'
require 'json'
describe TestdroidAPI::Config do
  before :all do
    VCR.use_cassette('pcp_oauth2_auth_config', :record => :new_episodes) do 
      @user = client_local_host("http://devel").authorize
    end
  end
  
  it 'get current project config params' do 
    project_name = "Android Project"
    VCR.use_cassette('pcp_get_current', :record => :new_episodes) do
      android_project = @user.projects.list.detect {|project| project.name.casecmp(project_name) == 0 }
      expect(android_project.config.parameters).to_not be_nil
      
    end
  end
  it 'set project config params' do 
    project_name = "Android Project"
    android_project = nil
    params_id = nil
    VCR.use_cassette('pcp_get_current', :record => :new_episodes) do
      android_project = @user.projects.list.detect {|project| project.name.casecmp(project_name) == 0 }
      expect(android_project.config.parameters).to_not be_nil
    end
    VCR.use_cassette('pcp_delete_params', :record => :new_episodes) do
      config_params = android_project.config.parameters.list_all.each { |param| param.delete}
    end

    VCR.use_cassette('pcp_set_current_config', :record => :new_episodes) do
      config_params = android_project.config.parameters.create({:params =>  {:key => 'KEY', :value => "VALUE"}})
      params_id = config_params.id

    end
    VCR.use_cassette('pcp_validate_config', :record => :new_episodes) do
       android_project = @user.projects.list.detect {|project| project.name.casecmp(project_name) == 0 }
       expect(android_project.config.parameters.get(params_id).key).to eq ('KEY')
       expect(android_project.config.parameters.get(params_id).value).to eq ('VALUE')
    end
    VCR.use_cassette('pcp_delete_params_final', :record => :new_episodes) do
      config_params = android_project.config.parameters.list_all.each { |param| param.delete}
    end
  end
end