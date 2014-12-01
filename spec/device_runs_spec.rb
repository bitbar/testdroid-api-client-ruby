require 'spec_helper'
require 'json'
describe TestdroidAPI::DeviceRun do
  before :all do
    
    VCR.use_cassette('dr_oauth2_auth_device_runs') do
      @user = client.authorize
    end
  end
  
  it 'get device runs' do 

    VCR.use_cassette('dr_run_33044722_device_runs') do
     
      expect(@user.projects.get(33029366).runs.get(33044722).device_runs).not_to be_nil
    
    end
  end
   it 'get device run using id' do 
    
     VCR.use_cassette('dr_device_run_33044722') do
        expect(@user.projects.get(33029366).runs.get(33044722).device_runs.get(33044966).id).to be(33044966)
     end
   end
end
