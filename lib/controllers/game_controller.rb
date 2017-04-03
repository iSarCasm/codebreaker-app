class GameController < ApplicationController
  def start_game
    session.clear
    session[:game] = Codebreaker::Game.new
    session[:game].start(params["diff"].to_sym)
    redirect '/play'
  end

  def play_page
    @attempts = Attempt.all
    render("play.html.erb")
    session[:error] = nil
  end

  def guess
    code = params["code"].split("").map{|x| x.to_i(16)}
    begin
      session[:respond] = game.guess(code)
      GuessAttempt.create(number: game.attempts_taken, type: params["code"], response: respond)
    rescue IndexError => e
      session[:error] = "You have to input #{game.symbols_count} chars."
    rescue ArgumentError => e
      session[:error] = "You have to input chars in range 1-#{game.symbols_range.to_s(16)}"
    ensure
      redirect (game.state == :playing ? '/play' : '/result')
    end
  end

  def get_hint
    HintAttempt.create(game.hint)
  rescue Exception => e
    session[:error] = e.message
  ensure
    redirect '/play'
  end

  def result_page
    @new_record = LeaderboardRecord.new(name: '', score: game.score)
    render("result.html.erb")
  end

  def save_record
    LeaderboardRecord.create(name: params["name"], score: game.score)
    redirect '/'
  end
end
