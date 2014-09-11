module TestdroidAPI
	class User < CloudResource
		def initialize(uri, client, params={})
			super uri, client,"users", params
			sub_items :projects, :device_groups, :device_sessions
		end
  	end
end