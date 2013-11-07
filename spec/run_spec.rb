require 'spec_helper'
require 'json'
describe TestdroidAPI::Run do
  before :all do
    VCR.use_cassette('r_oauth2_auth_runs') do
      @user = client.authorize
    end
  end
  
  it 'get runs' do 
    
    VCR.use_cassette('r_all_project_33029366_runs') do
      @user.projects.get(33029366).runs.list.should_not be nil
      
    end
  end
   it 'get run using id' do 
    
     VCR.use_cassette('r_run_171221') do
      @user.projects.get(33029366).runs.get(33044722).id.should == 33044722 
     end
   end
end
