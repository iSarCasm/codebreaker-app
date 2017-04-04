class GameController < ApplicationController
  def start_game
    session.clear
    Game.create(difficulty: params['diff'])
    redirect '/play'
  end

  def play_page
    @attempts = Attempt.all
    @game = Game.get
    @error = Error.get
    render("play.html.erb")
  end

  def guess
    game = Game.get
    begin
      respond = game.guess(params['code'])
      GuessAttempt.create(number: game.attempts_taken, type: params['code'], response: respond)
    rescue IndexError => e
      Error.create "You have to input #{game.symbols_count} chars."
    rescue ArgumentError => e
      Error.create "You have to input chars in range 1-#{game.symbols_range.to_s(16)}"
    ensure
      redirect game.current_page
    end
  end

  def get_hint
    HintAttempt.create(Game.get.hint)
  rescue Exception => e
    Error.create e.message
  ensure
    redirect '/play'
  end

  def result_page
    @game = Game.get
    @new_record = LeaderboardRecord.new(name: '', score: Game.get.score)
    render("result.html.erb")
  end

  def save_record
    LeaderboardRecord.create(name: params["name"], score: Game.get.score)
    redirect '/'
  end
end
