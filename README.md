testdroid-api-client-ruby
=========================

```
require 'testdroid-api-client'
#Authenticate
 client = TestdroidAPI::Client.new('admin@localhost', 'admin')
 @user = client.authorize
#get Projects
 projects = @user.projects.list

#get project by id
project_id = 123
project123 = @user.projects.get(project_id)
#output project name
p "Project name #{project123.name}"

#run project
test_run = project123.run

#check test run status
p "Project state #{test_run.state}"

#download all logs from test run
test_run.device_runs.list.each { |drun| drun.download_logs("#{drun.id}_log") }

#Get label for android os version 2.1
lg_android_version_2_1 = client.label_groups.list.detect {|lg| lg.display_name.casecmp("android version") == 0 }

os_v2_1 =  client.label_groups.get(lg_android_versions.id).labels.list.detect {|l| l.display_name.casecmp("2.1") == 0 }
        
 #get all devices with android os level 2.1
 devices = client.label_groups.get(lg_android_versions.id).labels.get(os_v2_1.id).devices
#get spefici device from devices list        
lenovo_a820 = devices.list.detect {|d| d.display_name == "Lenovo A820"}
       

```
See https://cloud.testdroid.com/swagger/index.html for more details about API V2
