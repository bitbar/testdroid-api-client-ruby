require 'spec_helper'
require 'json'
describe TestdroidAPI::Project do
  before :all do
    
    VCR.use_cassette('p_oauth2_auth') do
      @user = client.authorize
    end
  end
  it 'initialize from JSON object' do
    
    connection = double( :get => {"id"=>109674, "name"=>"Project 1", "description"=>"", "type"=>"ANDROID", "common"=>false, "sharedById"=>109625})
   
    project = Project.new('cloudUri', connection)
    project.id == 109674
    project.name == 'abc'
  end
  it 'get projects using client' do 
    
    VCR.use_cassette('p_all_projects') do
      @user.projects.list.should have(2).projects
    end
  end
  it 'get project using id' do 
    
    VCR.use_cassette('p_project_id_33029366') do
      @user.projects.get(33029366).common.should be_false
      @user.projects.get(33029366).id.should be 33029366
    end
  end
  it 'run project' do
    testRun = nil
    VCR.use_cassette('p_run_project') do
       testRun = @user.projects.get(33029366).run()
      
    end
    VCR.use_cassette('p_get_run_devices') do
       
       device_run =  testRun.device_runs.get(33044968)
       device_run.id
       p device_run.devices
    end
  end
end
