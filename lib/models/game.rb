class Game < SessionStorage
  extend SingleStorageUnit
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
