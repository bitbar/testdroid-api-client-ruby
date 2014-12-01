require 'spec_helper'
require 'json'
describe TestdroidAPI::DeviceGroup do
  before :all do
    VCR.use_cassette('dg_oauth2_auth_device_groups') do
      @user = client.authorize
    end
  end
  
  it 'get device groups' do 

    VCR.use_cassette('dg_all_device_groups') do
      
      device_groups = @user.device_groups
      expect(device_groups.total).to eq(1) 
      
    end
  end
   it 'get device group using id' do 
    
     VCR.use_cassette('dg_device_group_4165') do
      device_group_4165 = @user.device_groups.get(4165)
      expect(device_group_4165.id).to eq(4165) 
      expect(device_group_4165.display_name).to eq("testi grouppen")
      
     end
   end
end
