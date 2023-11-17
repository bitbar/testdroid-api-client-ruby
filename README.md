[![Gem Version](https://badge.fury.io/rb/testdroid-api-client.svg)](https://badge.fury.io/rb/testdroid-api-client)


Testdroid API Client for Ruby
=============================

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
project = @user.projects.list({:filter => "s_name_eq_MyProject"})[0]
```

## Get available frameworks
```ruby
frameworks = @user.available_frameworks.list
```

## Find specific framework
```ruby
framework = @user.available_frameworks.list({:filter => "s_osType_eq_ANDROID;s_name_like_%Instrumentation"})[0]
```

## Upload files
```ruby
file_app = @user.files.upload(File.join(File.dirname(__FILE__), "BitbarSampleApp.apk"))
file_test = @user.files.upload(File.join(File.dirname(__FILE__), "BitbarSampleAppTest.apk"))
```

## Start test run
```ruby
test_run = @user.runs.create("{\"osType\": \"ANDROID\", \"projectId\": #{project.id}, \"frameworkId\":#{framework_id},
  \"deviceIds\": #{id_list}, \"files\": [{\"id\": #{file_app.id}, \"action\": \"INSTALL\" },
  {\"id\": #{file_test.id}, \"action\": \"RUN_TEST\" }]}")

#See full list of params: https://docs.bitbar.com/testing/api/tests/index.html#details-about-the-configuration-fields
```

## Download all files from test run
```ruby
test_run.device_sessions.list({:limit => 0}).each { |ds| ds.download_all_files("YOUR_PATH") }
```

## Get all input files
```ruby
files = @user.files
files.list({:limit => 40,:filter => "s_direction_eq_INPUT"}).each { 
    |f| puts "File id: #{f.id} name: #{f.name}" }
```

See https://cloud.bitbar.com/cloud/swagger-ui.html for more details about API V2, make sure you are logged in.

Local development
=================

1. Install ruby
2. `bundle install`
3. Run tests: `rspec`, remove `spec/fixtures/cassettes` if you want to execute real Http requests
