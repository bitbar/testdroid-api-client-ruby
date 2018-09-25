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

## Get project by name
```ruby
android_project = @user.projects.list.detect {|project| project.name.casecmp("Android Project") == 0 }
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

## Get input files from project
```ruby
files = project123.files
files.list({:limit => 0}).each { |f| puts "File id: #{f.id} name: #{f.name}" }
```
## Get all input files
```ruby
files = user.files
files.list({:limit => 40,:filter => "s_direction_eq_INPUT"}).each { 
    |f| puts "File id: #{f.id} name: #{f.name}" }
```

## Delete input files older than 60days
```ruby
puts "deleting all input files older than 60 days - #{Time.at(Time.now.to_i  - ( 60 * 24 * 3600)    ).to_datetime}"
        
files.list({:limit => 40,:filter => "s_direction_eq_INPUT"}).each do |f|    
    if( f.create_time/1000 < (Time.now.to_i  - ( 60 * 24 * 3600) ))
        Time.at(Time.now.to_i  - (1000 * 60 * 24 * 3600)).to_datetime
        puts "Deleted file #{f.name}  created at #{Time.at(f.create_time/1000).to_datetime} "
        f.delete
    end
end
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
```ruby
#create a new device session: 
device_session = @user.device_sessions.create({:params =>  {'deviceModelId' => '1'}})

#release device session: 
device_session.release()

```


Project configuration
----
```ruby
#get project and update project configuration
android_project = @user.projects.list.detect {|project| project.name.casecmp("Android Project") == 0 }
android_project.config.update({:params => {'instrumentationRunner' => 'abc'}})
#See full list of params: http://docs.testdroid.com/_pages/client.html#update-project-config

```


See https://cloud.testdroid.com/swagger/index.html for more details about API V2
