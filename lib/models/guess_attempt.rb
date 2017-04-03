class GuessAttempt < Attempt
  def response
    '+ ' * @response[0] + '- ' * @response[1] # [0] - exact matches
  end                                         # [1] - close matches
end                                           # sorry for this one ;(
