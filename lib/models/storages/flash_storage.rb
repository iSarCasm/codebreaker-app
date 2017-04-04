module FlashStorage
  def all
    result = super
    clear
    result
  end
end
