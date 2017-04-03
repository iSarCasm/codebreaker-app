class HintAttempt < Attempt
  def initialize(response)
    @response = response
    @number   = 'HINT'
    @type     = 'HINT'
  end

  def response
    @response.map do |x|
      x || '*'
    end
  end
end
