require 'spec_helper'

describe TestdroidAPI::ApikeyClient do
  context "#initialize" do
    it "uses cloud.bitbar.com as default host" do
      expect(client.instance_variable_get('@cloud_url')).to eq "https://cloud.bitbar.com"
    end
  end

end
