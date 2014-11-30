
module TestdroidAPI
	class LabelGroups < CloudListResource
	end
	class LabelGroup < CloudResource
		def	initialize(uri, client, params= {})
			super uri, client,"labelGroup", params
			@uri, @client = uri, client
			sub_items :labels
		end

	end
end
