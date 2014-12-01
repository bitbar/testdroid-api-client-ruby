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
      expect(@user.projects.list.length).to be(2)
    end
  end
  it 'get project using id' do 
    
    VCR.use_cassette('p_project_id_33029366') do
      expect(@user.projects.get(33029366).common).to be_falsey
      expect(@user.projects.get(33029366).id).to eq 33029366
    end
  end
  it 'run project' do
    testRun = nil
    VCR.use_cassette('p_run_project') do
       testRun = @user.projects.get(33029366).run()
      
    end
    VCR.use_cassette('p_get_run_devices') do
       
       device_run =  testRun.device_runs.get(33044968)
       expect(device_run.device['displayName']).to eq "Alcatel One Touch 991"
    end
  end
  it 'creates project' do

    VCR.use_cassette('p_oauth2_local') do
      
      @user_local = client_local_host.authorize
    end
    VCR.use_cassette('p_create_project') do
      puts "Before"
      my_project = @user_local.projects.create({:params => {:name => 'My Project'}})
      expect(my_project.name).to eq 'My Project'
    end
    
  end
end
