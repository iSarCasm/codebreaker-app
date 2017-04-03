class SessionStorage < Storage
  def self.all
    session[storage_path]  || []
  end

  def save
    session[storage_path] = all << self
  end

  def self.session
    Application.request.session
  end

  def session
    self.class.session
  end
end
