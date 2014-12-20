require 'spec_helper'
require 'json'
describe TestdroidAPI::Config do
  before :all do
    VCR.use_cassette('pc_oauth2_auth_config', :record => :new_episodes) do 
      @user = client_local_host("http://localhost:9080/testdroid-cloud").authorize
    end
  end
  
  it 'get current project config' do 
    project_name = "Android Project"
    VCR.use_cassette('pc_get_current', :record => :new_episodes) do
      android_project = @user.projects.list.detect {|project| project.name.casecmp(project_name) == 0 }
      expect(android_project.config).to_not be_nil
      
    end
  end
  it 'set project config' do 
    project_name = "Android Project"
    android_project = nil
    VCR.use_cassette('pc_get_current', :record => :new_episodes) do
      android_project = @user.projects.list.detect {|project| project.name.casecmp(project_name) == 0 }
      expect(android_project.config).to_not be_nil
     
    end
    VCR.use_cassette('pc_set_current_config', :record => :new_episodes) do
      android_project.config.update({:params =>  {:instrumentationRunner => 'com.my.test.Runner', :timeout => 100}})

    end
    VCR.use_cassette('pc_validate_config', :record => :new_episodes) do
       android_project = @user.projects.list.detect {|project| project.name.casecmp(project_name) == 0 }
       expect(android_project.config.instrumentation_runner).to eq ('com.my.test.Runner')
    end

  end
end
