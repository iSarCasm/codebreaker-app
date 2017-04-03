class Attempt < SessionStorage
  attr_reader :number, :type, :response

  def self.storage_path
    :play_history
  end

  def initialize(number:, type:, response:)
    @number   = number
    @type     = type
    @response = response
  end
end
