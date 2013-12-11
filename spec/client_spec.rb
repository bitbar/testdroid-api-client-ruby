require 'spec_helper'

describe TestdroidAPI::Client do 
	context "#initialize" do 
		it "uses cloud.testdroid.com as default host" do
     		client.instance_variable_get('@cloud_url').should eq "https://cloud.testdroid.com"
    	end
	end

end