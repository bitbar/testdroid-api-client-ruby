require 'spec_helper'
require 'json'
describe TestdroidAPI::Project do
  before :all do
    VCR.use_cassette(File.basename(__FILE__).split('_spec')[0] + '_authorize') do
      @user = client_local_host.authorize
    end
  end

  P_ID = nil

  it 'create project' do
    VCR.use_cassette(File.basename(__FILE__).split('_spec')[0] + '_create') do
      project = @user.projects.create({:params => {:name => 'My Project'}})
      expect(project.name).to eq 'My Project'
      P_ID = project.id
    end
  end

  it 'get projects' do
    VCR.use_cassette(File.basename(__FILE__).split('_spec')[0] + '_get_all') do
      expect(@user.projects.list.length).to satisfy {|n| n > 0}
    end
  end

  it 'get project using id' do
    VCR.use_cassette(File.basename(__FILE__).split('_spec')[0] + '_get_one') do
      project = @user.projects.get(P_ID)
      expect(project.common).to be_falsey
      expect(project.name).to eq('My Project')
      expect(project.id).to eq(P_ID)
    end
  end

  it 'delete project' do
    VCR.use_cassette(File.basename(__FILE__).split('_spec')[0] + '_delete') do
      @user.projects.get(P_ID).delete
    end
  end

end
