require 'spec_helper'
require 'json'
describe TestdroidAPI::FileSets do
  before :all do
    VCR.use_cassette('fs_oauth2_auth_files') do
      @user = client_local_host.authorize
      @user.file_sets.list.each{  |fs| fs.delete}
    end
  end

  it 'get file sets ' do
    VCR.use_cassette('fs_file_sets') do
      fs =  @user.file_sets
      expect(fs.total).to be == 0
    end
  end
  it 'Add a new file set ' do
    VCR.use_cassette('fs_add_file_set') do
      fs =  @user.file_sets.create({:params => {:name => 'My File Set'}})
      expect(fs.name).to eq "My File Set"
    end
  end
  it 'Get new file set ' do
    VCR.use_cassette('fs_get_file_set') do
      @user.file_sets.list.each{ |fs|
        expect(fs.name).to eq "My File Set"
      }
    end
  end
  it 'Update file set ' do
    VCR.use_cassette('fs_update_file_set') do
      fs1 =  @user.file_sets.list.first
      fs1.update({:params => {:name => 'My File Set 2'}})
      expect(fs1.name).to eq "My File Set 2"
    end
  end

  it 'Delete file set ' do
    VCR.use_cassette('fs_delete_file_set') do
      fs1 =  @user.file_sets.list.first
      fs1.delete
      fs1 = @user.file_sets.list.first
      puts fs1
      expect(fs1).to be_nil
    end
  end
end
