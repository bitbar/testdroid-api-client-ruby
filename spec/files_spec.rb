require 'spec_helper'
require 'json'
describe TestdroidAPI::Files do
  before :all do
    VCR.use_cassette('f_oauth2_auth_files') do
      @user = client.authorize
    end
  end
  
  it 'get app file ' do 
    project33029366 = nil
    VCR.use_cassette('f_android_app_file') do
       project33029366 =  @user.projects.get(33029366)
       project33029366.files.app.should_not eq nil
      
    end
  end
  it 'upload apks' do 
    project33029366 = nil
    VCR.use_cassette('f_get_project_33029366') do
      
      project33029366 =  @user.projects.get(33029366)
      project33029366.should_not eq nil
    end
    VCR.use_cassette('upload_files') do
      file_name = 'apk.apk'
      file_path = File.join(File.dirname(__FILE__), 'fixtures', file_name)
      reply = project33029366.files.uploadApplication(file_path)
      expect(reply.original_name).to eq(file_name)
      
    end
  end
end
