class Attempt < SessionStorage
  attr_reader :number, :type, :response

  def self.storage_path
    :play_history
  end

  def initialize(type:, response:)
    @number   = Game.get.attempts_taken
    @type     = type
    @response = response
  end
end
