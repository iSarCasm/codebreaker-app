class Attempt
  def self.all
    session[:play_history]  || []
  end

  def self.create(number:, type:, response:)
    new(number: number, type: type, response: response).save
  end

  attr_reader :number, :type, :response

  def initialize(number:, type:, response:)
    @number   = number
    @type     = type
    @response = response
  end

  def save
    session[:play_history] = self.class.all << add
  end
end
