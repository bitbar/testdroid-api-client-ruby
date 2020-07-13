require 'spec_helper'
require 'json'
describe TestdroidAPI::Files do
  before :all do
    VCR.use_cassette(File.basename(__FILE__).split('_spec')[0] + '_authorize') do
      @user = client_local_host.authorize
    end
  end

  F_ID = nil

  it 'upload file' do
    VCR.use_cassette(File.basename(__FILE__).split('_spec')[0] + '_upload') do
      file_name = 'apk.apk'
      file_path = File.join(File.dirname(__FILE__), 'fixtures', file_name)
      file = @user.files.upload(file_path)
      F_ID = file.id
      expect(file.name).to eq(file_name)
    end
  end

  it 'upload with wait' do
    VCR.use_cassette(File.basename(__FILE__).split('_spec')[0] + '_upload_with_wait') do
      uploaded = []
      ['data.txt', 'data2.txt'].each do |file_name|
        file = @user.files.upload(File.join(File.dirname(__FILE__), 'fixtures', file_name), true)
        uploaded.push(file)
      end
      @user.files.wait_for_virus_scan(uploaded, 120)
    end
  end

  it 'get file' do
    VCR.use_cassette(File.basename(__FILE__).split('_spec')[0] + '_get_one') do
      file = @user.files.get(F_ID)
      expect(file.name).to eq('apk.apk')
      expect(file.id).to eq(F_ID)
    end
  end

  it 'get files' do
    VCR.use_cassette(File.basename(__FILE__).split('_spec')[0] + '_get_all') do
      files = @user.files
      expect(files.total).to satisfy {|n| n > 0}
    end
  end

  it 'delete file' do
    VCR.use_cassette(File.basename(__FILE__).split('_spec')[0] + '_delete') do
      @user.files.get(F_ID).delete
    end
  end
end
