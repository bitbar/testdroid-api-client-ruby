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
    VCR.use_cassette('p_run_project') do
       runName = @user.projects.get(33029366).run().display_name
       expect(runName).to eq("Test Run 2")
    end
  end
end
