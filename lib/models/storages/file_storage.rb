class SessionStorage
  def self.all
    database = File.open(storage_path)
    YAML.load_stream(database) || []
  end

  def save
    database = File.open(storage_path, 'a+')
    database.write(self.to_yaml)
    database.close
  end
end
