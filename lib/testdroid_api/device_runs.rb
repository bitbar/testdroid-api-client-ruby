
module TestdroidAPI
		class DeviceRuns < CloudListResource
		end
		class DeviceRun < CloudResource
			def	initialize(uri, client, params= {})
				super uri, client,"deviceRun", params
				@uri, @client = uri, client
			end
      def download_scrshots_zip(file_name="screenshots.zip")
        if(screenshots_u_r_i.nil? || screenshots_u_r_i.empty? )
        	@client.logger.warn( "Screenshots are not available")
        	return nil
        end
        @client.download(screenshots_u_r_i, "screenshots.zip", file_name)
      end
      def download_junit(file_name="junit.xml")
      	if(junit_u_r_i.nil? || junit_u_r_i.empty? )
        	@client.logger.warn( "Junit result is not available")
        	return nil
        end
        @client.download(junit_u_r_i, "junit XML", file_name)
      end
      def download_logcat(file_name="logcat.txt")
        if(log_u_r_i.nil? || log_u_r_i.empty? )
        	@client.logger.warn( "Logcat output is not available")
        	return nil
        end
        @client.download(log_u_r_i, "log", file_name)
      end
		end
end
