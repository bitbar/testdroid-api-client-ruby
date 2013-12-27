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

```
See https://cloud.testdroid.com/swagger/index.html for more details about API V2
