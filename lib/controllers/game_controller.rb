class GameController < ApplicationController::Base
  include ApplicationHelper

  def start_game
    Rack::Response.new do |response|
      @request.session.clear
      clear_game_cookies(response)
      @request.session[:game] = Codebreaker::Game.new
      @request.session[:game].start(@request.params["diff"].to_sym)
      response.redirect("/play")
    end
  end

  def play_page
    @request.session[:error] = nil
    Rack::Response.new(render("play.html.erb"))
  end

  def guess
    Rack::Response.new do |response|
      code = @request.params["code"].split("").map{|x| x.to_i(16)}
      begin
        @request.session[:respond] = game.guess(code)
        add_play_cookie(response, [game.attempts_taken, @request.params["code"], formated_respond])
      rescue IndexError => e
        @request.session[:error] = "You have to input #{game.symbols_count} chars."
      rescue ArgumentError => e
        @request.session[:error] = "You have to input chars in range 1-#{game.symbols_range.to_s(16)}"
      ensure
        if game.state == :playing
          response.redirect("/play")
        else
          response.redirect("/result")
        end
      end
    end
  end

  def get_hint
    Rack::Response.new do |response|
      begin
        @request.session[:hint] = game.hint
        add_play_cookie(response, ['HINT', 'HINT', formated_hint])
      rescue Exception => e
        @request.session[:error] = e.message
      ensure
        response.redirect("/play")
      end
    end
  end

  def result_page
    Rack::Response.new(render("result.html.erb"))
  end

  def save_record
    Rack::Response.new do |response|
      db = File.open(DB_PATH, 'a+')
      loaded = [@request.params["name"], game.score]
      db.write(loaded.to_yaml)
      db.close
      response.redirect("/")
    end
  end
end
