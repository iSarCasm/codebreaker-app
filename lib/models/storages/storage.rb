class Storage
  def self.create(*args, &block)
    new(*args, &block).add
  end

  def storage_path
    self.class.storage_path
  end

  def all
    self.class.all
  end
end
