Testdroid API Client for Ruby
=========================


## Installation

```ruby
# Gemfile
gem "testdroid-api-client"
```

```bash
> bundle install
```
## Sample client usage - Authenticate
```ruby
require 'testdroid-api-client'

client = TestdroidAPI::Client.new('admin@localhost', 'admin')
```
## Sample usage - get projects
```ruby
 @user = client.authorize
 projects = @user.projects.list
```
## Get project by id
```ruby
project_id = 123
project123 = @user.projects.get(project_id)
#output project name
p "Project name #{project123.name}"
```

## Start project
```ruby
test_run = project123.run
```

## Check test run status
```ruby
p "Project state #{test_run.state}"

```
## Download all logs from test run
```ruby
test_run.device_runs.list({:params => {:limit => 100}}).each { |drun| drun.download_logs("#{drun.id}_log") }
```

## Using device labels
```ruby
#Get label for android os version 2.1
lg_android_version_2_1 = client.label_groups.list.detect {|lg| lg.display_name.casecmp("android version") == 0 }

os_v2_1 =  client.label_groups.get(lg_android_versions.id).labels.list.detect {|l| l.display_name.casecmp("2.1") == 0 }
        
 #get all devices with android os level 2.1
 devices = client.label_groups.get(lg_android_versions.id).labels.get(os_v2_1.id).devices
#get spefici device from devices list        
lenovo_a820 = devices.list.detect {|d| d.display_name == "Lenovo A820"}
       
       
```
Device Sessions
----
```
To create a new device session: 
device_session = user.device_sessions.create({:params =>  {'deviceModelId' => '1'}})

To release device session: 
device_session.release()

```

See https://cloud.testdroid.com/swagger/index.html for more details about API V2
