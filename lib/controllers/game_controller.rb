class GameController < ApplicationController
  def start
    session.clear
    Game.create(difficulty: params['diff'])
    redirect '/play'
  end

  def play
    @attempts = Attempt.all
    @game = Game.get
    @error = Error.get
    render 'play'
  end

  def guess
    respond = Game.get.guess(params['code'])
    unless respond.kind_of? Error
      GuessAttempt.create(type: params['code'], response: respond)
    end
    redirect Game.get.current_page
  end

  def hint
    hint = Game.get.hint
    HintAttempt.create(hint) unless hint.kind_of? Error
    redirect '/play'
  end

  def result
    @game = Game.get
    @new_record = LeaderboardRecord.new(score: Game.get.score)
    render 'result'
  end

  def save_record
    LeaderboardRecord.create(name: params["name"], score: Game.get.score)
    redirect '/'
  end
end
