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
    respond = Game.get.guess(params['code'])
    unless respond.kind_of? Error
      GuessAttempt.create(type: params['code'], response: respond)
    end
    redirect Game.get.current_page
  end

  def get_hint
    hint = Game.get.hint
    HintAttempt.create(hint) unless hint.kind_of? Error 
    redirect '/play'
  end

  def result_page
    @game = Game.get
    @new_record = LeaderboardRecord.new(score: Game.get.score)
    render("result.html.erb")
  end

  def save_record
    LeaderboardRecord.create(name: params["name"], score: Game.get.score)
    redirect '/'
  end
end
