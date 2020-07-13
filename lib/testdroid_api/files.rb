module TestdroidAPI
  class Files < CloudListResource

    ACCEPTED_VIRUS_SCAN_STATUSES = Set['safe', 'disabled', nil]

    def upload(filename, skip_scan_wait=false)
      unless ::File.exist?(filename)
        @client.logger.error("Invalid filename")
        return
      end
      file = @client.upload("#{@uri}", filename)
      result = File.new("#{@uri}/#{file['id']}", @client, file)
      if !skip_scan_wait
        wait_for_virus_scan(Array(result))
      end
      return result
    end

    def wait_for_virus_scan(api_files, timeout=300)
      all_safe = false
      begin
        Timeout.timeout(timeout) do
          while !all_safe do
            statuses = Set.new
            api_files.each do |file|
              current_status = get_virus_scan_status(file)
              if ACCEPTED_VIRUS_SCAN_STATUSES.include?(current_status)
                statuses.add(current_status)
              else
                sleep(1)
                file.refresh
                statuses.add(get_virus_scan_status(file))
              end
            end
            if statuses.include?('infected')
              raise 'File rejected by virus scan'
            end
            if ACCEPTED_VIRUS_SCAN_STATUSES.superset?(statuses)
              all_safe = true
            end
          end
        end
      rescue Timeout::Error
        @client.logger.error("Waiting for virus scan timed out")
        raise
      end
    end

    private

    def get_virus_scan_status(file)
      return file.file_properties.find{ |item| item['key'] == "virus_scan_status" }['value']
    end
  end

  class File < CloudResource
    def initialize(uri, client, params = {})
      super uri, client, "file", params
      @uri, @client = uri, client
    end
  end
end
