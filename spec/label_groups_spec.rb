require 'spec_helper'
require 'json'
describe TestdroidAPI::LabelGroups do
  before :all do
    VCR.use_cassette('lg_oauth2_auth_label_groups') do
      @user = client.authorize
    end
  end
  
  it 'get label groups' do 
    
    VCR.use_cassette('lg_all_label_groups') do
      
      label_groups = client.label_groups
      p 'ssdlksldklskdls'
      p label_groups
      
      expect(label_groups.total).to be(13) 
      
    end
  end
  it 'get label group using id' do  
    
     VCR.use_cassette('lg_label_group_1058800') do
      label_group_1058800 = client.label_groups.get(1058800)
      expect(label_group_1058800.id).to be(1058800) 
      expect(label_group_1058800.display_name).to eq("API Level")
      
     end
   end
   it 'get labels from label group using id' do 
    
     VCR.use_cassette('lg_labels_of_group_1058800') do
      client.label_groups.get(1058800).labels
      
     end
   end
   it ' get resources by label' do
      VCR.use_cassette('lg_get_resources_by_label') do

        lg_android_versions = client.label_groups.list.detect {|lg| lg.display_name.casecmp("android version") == 0 }

        os_v2_1 =  client.label_groups.get(lg_android_versions.id).labels.list.detect {|l| l.display_name.casecmp("2.1") == 0 }
        
        #get all devices with android os level 2.1
        devices = client.label_groups.get(lg_android_versions.id).labels.get(os_v2_1.id).devices
        lenovo_a820 = devices.list.detect {|d| d.display_name == "Lenovo A820"}
        expect(lenovo_a820.display_name).to eq("Lenovo A820")
        
        
     end
   end

end
