class SessionStorage < Storage
  def self.all
    session[storage_path]  || []
  end

  def self.clear
    session[storage_path] = nil
  end

  def add
    session[storage_path] = all << self
    self
  end

  def self.session
    Application.request.session
  end

  def session
    self.class.session
  end
end
