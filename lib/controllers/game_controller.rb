class GameController < ApplicationController
  include ApplicationHelper

  def start_game
    session.clear
    session[:game] = Codebreaker::Game.new
    session[:game].start(params["diff"].to_sym)
    redirect '/play'
  end

  def play_page
    render("play.html.erb")
    session[:error] = nil
  end

  def guess
    code = params["code"].split("").map{|x| x.to_i(16)}
    begin
      session[:respond] = game.guess(code)
      append_play_history([game.attempts_taken, params["code"], formated_respond])
    rescue IndexError => e
      session[:error] = "You have to input #{game.symbols_count} chars."
    rescue ArgumentError => e
      session[:error] = "You have to input chars in range 1-#{game.symbols_range.to_s(16)}"
    ensure
      redirect (game.state == :playing ? '/play' : '/result')
    end
  end

  def get_hint
    session[:hint] = game.hint
    append_play_history(['HINT', 'HINT', formated_hint])
  rescue Exception => e
    session[:error] = e.message
  ensure
    redirect '/play'
  end

  def result_page
    render("result.html.erb")
  end

  def save_record
    db = File.open(DB_PATH, 'a+')
    loaded = [params["name"], game.score]
    db.write(loaded.to_yaml)
    db.close
    redirect '/'
  end

  private

  def append_play_history(add)
    history = (request.session[:play_history] || []) << add
    session[:play_history] = history
  end
end
