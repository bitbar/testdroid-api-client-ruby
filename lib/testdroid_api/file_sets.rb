module TestdroidAPI
  class FileSets < CloudListResource
  end
  class FileSet < CloudResource
    def initialize(uri, client, params= {})
      super uri, client, "fileSet", params
      @uri, @client = uri, client
      sub_items :files
    end
  end
end
