class SessionStorage < Storage
  def self.all
    session[storage_path]  || []
  end

  def save
    session[storage_path] = all << self
  end
end
