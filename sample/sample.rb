require 'testdroid-api-client'

client = TestdroidAPI::Client.new('admin@localhost', 'admin')
#to use private cloud specify cloud url as:
#client = TestdroidAPI::Client.new('my@host.com', 'hostpass', 'https://customer.testdroid.com/cloud')
#oauth
user = client.authorize

# Create Android project
android_project = user.projects.create({:params => {:name => "Android robotium", :type => "ANDROID"}})

# Create iOS project
ios_project = user.projects.create({:params => {:name => "iOS project", :type => "IOS"}})

#Android applicaiton
android_project.files.uploadApplication("BitbarSampleApp.apk")

#instrumentation package
android_project.files.uploadTest("BitbarSampleAppTests.apk")


#Set custom runner and set mode for instrumentaiton test
android_project.config.update({:params => {'instrumentationRunner' => 'com.testrunners.MyRunner', :mode=> 'FULL_RUN'}})

#get all the Android devices
android_devices = client.devices.list.select {|device| device.os_type.casecmp("ANDROID") == 0 }

#get IDs of the android devices
id_list = android_devices.collect{|device| device.id } 

run_parameters = {:params => {:name => 'Test run 1', "usedDeviceIds[]" => id_list.join(',') }}
#Run project using the parameters
android_project.run(run_parameters)

#wait until the whole test run is completed
sleep 20 until android_project.runs.list.first.state == "FINISHED"

#download junit xml from the all device runs
android_project.runs.list.first.device_runs.list({:params => {:limit => 0}}).each { |device_run| device_run.download_junit("#{device_run.id}_junit.xml") }
