class FileStorage < Storage
  def self.all
    database = File.open(storage_path)
    YAML.load_stream(database) || []
  end

  def self.clear
    File.truncate(storage_path, 0)
  end

  def add
    database = File.open(storage_path, 'a+')
    database.write(self.to_yaml)
    database.close
  end
end
