class Game < SessionStorage
  extend SingleUnitStorage
  attr_reader :codebreaker_game

  def self.storage_path
    :game
  end

  def initialize(difficulty:)
    @codebreaker_game = Codebreaker::Game.new
    @codebreaker_game.start(difficulty.to_sym)
  end

  def guess(code)
    code = code.split('').map { |x| x.to_i(16) }
    codebreaker_game.guess(code)
  rescue IndexError => e
    Error.create "You have to input #{symbols_count} chars."
  rescue ArgumentError => e
    Error.create "You have to input chars in range 1-#{symbols_range.to_s(16)}"
  end

  def hint
    codebreaker_game.hint
  rescue Exception => e
    Error.create e.message
  end

  def current_page
    state == :playing ? '/play' : '/result'
  end

  def method_missing(method, *args)
    if codebreaker_game.respond_to?(method)
      codebreaker_game.send(method, *args)
    else
      super
    end
  end
end
