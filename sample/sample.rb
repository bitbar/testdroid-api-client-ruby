require 'testdroid-api-client'

client = TestdroidAPI::Client.new(ENV['TESTDROID_USERNAME'],ENV['TESTDROID_PASSWORD'])
#or using api key:
#client = TestdroidAPI::ApikeyClient.new(ENV['TESTDROID_APIKEY'])
#to use private cloud specify cloud url as:
#client = TestdroidAPI::Client.new('API_KEY', 'https://customer.testdroid.com')
user = client.authorize

# Create Android project
android_project = user.projects.create({:name => "Android instrumentation", :type => "ANDROID"})

# Create iOS project
ios_project = user.projects.create({:name => "iOS project", :type => "IOS"})

#Android applicaiton
file_app = android_project.files.uploadApplication("BitbarSampleApp.apk")

#instrumentation package
file_test = android_project.files.uploadTest("BitbarSampleAppTest.apk")

#Set custom runner and set mode for instrumentaiton test
android_project.config.update({'instrumentationRunner' => 'com.testrunners.MyRunner', :mode=> 'FULL_RUN'})

#get all the Android devices
android_devices = client.devices.list.select {|device| device.os_type.casecmp("ANDROID") == 0 }

#get IDs of the android devices
id_list = android_devices.collect{|device| device.id } 

run_parameters = {
    :name => 'Test run 1',
    "usedDeviceIds[]" => id_list.join(','),
    :appFileId => file_app.id,
    :testFileId => file_test.id
}
#Run project using the parameters
android_project.run(run_parameters)

#wait until the whole test run is completed
sleep 20 until android_project.runs.list.first.state == "FINISHED"

#download junit xml from the all device runs
android_project.runs.list.first.device_runs.list({:limit => 0}).each { |device_run| device_run.download_junit("#{device_run.id}_junit.xml") }
