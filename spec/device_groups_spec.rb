require 'spec_helper'
require 'json'
describe TestdroidAPI::DeviceGroup do
  before :all do
    VCR.use_cassette(File.basename(__FILE__).split('_spec')[0] + '_authorize') do
      @user = client_local_host.authorize
    end
  end

  DG_ID = nil

  it 'create device group' do
    VCR.use_cassette(File.basename(__FILE__).split('_spec')[0] + '_create') do
      device_group = @user.device_groups.create({:displayName => 'Empty'})
      DG_ID = device_group.id
    end
  end

  it 'get device groups' do
    VCR.use_cassette(File.basename(__FILE__).split('_spec')[0] + '_get_all') do
      device_groups = @user.device_groups
      expect(device_groups.total).to satisfy { |n| n > 0 }
    end
  end

  it 'get device group using id' do
    VCR.use_cassette(File.basename(__FILE__).split('_spec')[0] + '_get_one') do
      device_group = @user.device_groups.get(DG_ID)
      expect(device_group.id).to eq(DG_ID)
      expect(device_group.display_name).to eq("Empty")

    end
  end

  it 'delete device group' do
    VCR.use_cassette(File.basename(__FILE__).split('_spec')[0] + '_delete') do
      @user.device_groups.get(DG_ID).delete
    end
  end

end
