require 'spec_helper'
require 'json'
describe TestdroidAPI::Project do
  before :all do
    VCR.use_cassette(File.basename(__FILE__).split('_spec')[0] + '_authorize') do
      @user = client_local_host.authorize
    end
  end

  P_ID = nil
  TR_ID = nil

  it 'start test run' do
    VCR.use_cassette(File.basename(__FILE__).split('_spec')[0] + '_start_run') do
      framework_id = @user.available_frameworks.list({:filter => "s_osType_eq_ANDROID;s_name_like_%AppCrawler"})[0].id
      app_file_id = @user.files.upload(File.join(File.dirname(__FILE__), 'fixtures', 'apk.apk')).id

      test_run = @user.runs.create("{\"osType\": \"ANDROID\", \"projectName\": \"My new Project\",
          \"frameworkId\":#{framework_id}, \"files\": [{\"id\": #{app_file_id}, \"action\": \"INSTALL\" }]}")

      P_ID = test_run.project_id
      TR_ID = test_run.id
    end
  end

  it 'get project test runs' do
    VCR.use_cassette(File.basename(__FILE__).split('_spec')[0] + '_get_project_runs') do
      test_runs = @user.projects.get(P_ID).runs
      expect(test_runs.total).to eq(1)
    end
  end

  it 'abort test run' do
    VCR.use_cassette(File.basename(__FILE__).split('_spec')[0] + '_abort_run') do
      test_run = @user.projects.get(P_ID).runs.get(TR_ID)
      test_run.abort
      expect(test_run.state).to eq("FINISHED")
    end
  end

end
