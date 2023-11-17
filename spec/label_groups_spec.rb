require 'spec_helper'
require 'json'
describe TestdroidAPI::LabelGroups do
  before :all do
    VCR.use_cassette(File.basename(__FILE__).split('_spec')[0] + '_authorize') do
      @user = client_local_host.authorize
    end
  end

  it 'get label groups' do
    VCR.use_cassette(File.basename(__FILE__).split('_spec')[0] + '_get_all') do
      label_groups = client_local_host.label_groups
      expect(label_groups.total).to satisfy { |n| n > 0 }
    end
  end

  LG_ID = nil

  it 'create label group' do
    VCR.use_cassette(File.basename(__FILE__).split('_spec')[0] + '_create') do
      label_group = client_local_host.label_groups.create({:displayName => 'Empty', :name => 'empty'})
      LG_ID = label_group.id
    end
  end

  it 'get label group using id' do
    VCR.use_cassette(File.basename(__FILE__).split('_spec')[0] + '_get_one') do
      label_group = client_local_host.label_groups.get(LG_ID)
      expect(label_group.id).to be(LG_ID)
      expect(label_group.display_name).to eq('Empty')
    end
  end

  it 'get labels from label group using id' do
    VCR.use_cassette(File.basename(__FILE__).split('_spec')[0] + '_get_labels') do
      labels = client_local_host.label_groups.get(LG_ID).labels
      expect(labels.total).to eq(0)
    end
  end

  it 'delete label group' do
    VCR.use_cassette(File.basename(__FILE__).split('_spec')[0] + '_delete') do
      client_local_host.label_groups.get(LG_ID).delete
    end
  end

end
