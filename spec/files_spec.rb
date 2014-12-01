require 'spec_helper'
require 'json'
describe TestdroidAPI::Files do
  before :all do
    VCR.use_cassette('fu_oauth2_auth_files') do 
      @user = client_local_host.authorize
    end
  end
  
  it 'get app file ' do 
    project33029366 = nil
    VCR.use_cassette('f_android_app_file') do
       project33029366 =  @user.projects.get(100800)
       expect(project33029366.files.app).to_not be_nil
      
    end
  end
  it 'upload apks' do 
    project33029366 = nil
    VCR.use_cassette('f_get_project_33029366') do
      
      project33029366 =  @user.projects.get(100800)
      expect(project33029366).to_not be_nil
    end
    VCR.use_cassette('f_upload_files') do
      file_name = 'apk.apk'
      file_path = File.join(File.dirname(__FILE__), 'fixtures', file_name)
      reply = project33029366.files.uploadApplication(file_path)
      expect(reply.original_name).to eq(file_name)
      
    end
  end
end
