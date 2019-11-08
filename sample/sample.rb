require 'testdroid-api-client'

client = TestdroidAPI::Client.new(ENV['BITBAR_USERNAME'], ENV['BITBAR_PASSWORD'])
#or using api key:
#client = TestdroidAPI::ApikeyClient.new(ENV['BITBAR_APIKEY'])
#to use private cloud specify cloud url as:
#client = TestdroidAPI::Client.new('API_KEY', 'https://customer.bitbar.com')
user = client.authorize

# Create project
project = user.projects.create({:name => "Android instrumentation"})

#Upload file
file_app = user.files.upload(File.join(File.dirname(__FILE__), "BitbarSampleApp.apk"))

#instrumentation package
file_test = user.files.upload(File.join(File.dirname(__FILE__), "BitbarSampleAppTest.apk"))

#get all the Android devices
android_devices = client.devices.list({:filter => "s_osType_eq_ANDROID"})

#get IDs of the android devices
id_list = android_devices.collect(&:id)

#get Android Instrumentation
framework_id = user.available_frameworks.list({:filter => "s_osType_eq_ANDROID;s_name_like_%Instrumentation"})[0].id

#start test run
test_run = user.runs.create("{\"osType\": \"ANDROID\", \"projectId\": #{project.id}, \"frameworkId\":#{framework_id},
  \"deviceIds\": #{id_list}, \"files\": [{\"id\": #{file_app.id}, \"action\": \"INSTALL\" },
  {\"id\": #{file_test.id}, \"action\": \"RUN_TEST\" }]}")


#wait until the whole test run is completed
sleep 20 until test_run.refresh.state == "FINISHED"

#download all files from all device sessions
test_run.device_sessions.list({:limit => 0})
    .each {|ds| ds.download_all_files(File.join(File.dirname(__FILE__), "results"))}
