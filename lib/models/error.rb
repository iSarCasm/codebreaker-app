class Error < SessionStorage
  extend SingleUnitStorage
  extend FlashStorage
  attr_reader :text

  def self.storage_path
    :error
  end

  def initialize(text)
    @text = text
  end

  def to_s
    text
  end
end
