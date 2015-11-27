require "erb"
require "codebreaker"
require 'yaml'

class Racker
  def self.call(env)
    new(env).response.finish
  end

  def initialize(env)
    @request = Rack::Request.new(env)
  end

  def response
    case @request.path
    when "/"            then Rack::Response.new(render("index.html.erb"))
    when "/start_game"  then start_game
    when "/play"        then Rack::Response.new(render("play.html.erb"))
    when "/guess"       then guess
    when "/hint"        then get_hint
    when "/result"      then Rack::Response.new(render("result.html.erb"))
    when "/record"      then save_record
    else Rack::Response.new("Not Found", 404)
    end
  end

  def start_game
    Rack::Response.new do |response|
      clear_session
      clear_cookies(response)
      @request.session[:game] = Codebreaker::Game.new
      game.start(@request.params["diff"].to_sym)
      response.redirect("/play")
    end
  end

  def guess
    Rack::Response.new do |response|
      code = @request.params["code"].split("").map{|x| x.to_i(16)}
      begin
        @request.session[:respond] = game.guess(code)
        add_play_history(response, [game.attempts_taken, @request.params["code"], formated_respond])
      rescue IndexError => e
        @request.session[:error] = "You have to input #{game.symbols_count} chars"
        response.redirect("/play")
      end
      if game.state == :playing
        response.redirect("/play")
      else
        response.redirect("/result")
      end
    end
  end

  def get_hint
    Rack::Response.new do |response|
      begin
        @request.session[:hint] = game.hint
        add_play_history(response, ['HINT', 'HINT', formated_hint])
        response.redirect("/play")
      rescue Exception => e
        @request.session[:error] = e.message
        response.redirect("/play")
      end
    end
  end

  def save_record
    Rack::Response.new do |response|
      path = File.expand_path("../../db/records.yml", __FILE__)
      db = File.open(path,'a+')
      loaded = [@request.params["name"], game.score]
      db.write(loaded.to_yaml)
      db.close
      response.redirect("/")
    end
  end

  def leaderboards
    path = File.expand_path("../../db/records.yml", __FILE__)
    db = File.open(path)
    loaded = YAML.load_stream(db)
    loaded.sort! do |x1, x2|
      x2[1] <=> x1[1]
    end
    loaded.map!.with_index do |x, i|
      x.insert(0, i+1)
    end
    loaded
  end

  def render(template)
    path = File.expand_path("../views/#{template}", __FILE__)
    ERB.new(File.read(path)).result(binding)
  end

  def clear_session
    @request.session.clear
  end

  def clear_cookies(response)
    response.delete_cookie("play_story")
  end

  def add_play_history(response, add)
    if @request.cookies["play_story"]
      history = YAML.load(@request.cookies["play_story"])
      history << add
    else
      history = [add]
    end
    history = YAML.dump(history)
    response.set_cookie("play_story", history)
  end

  def play_history
    YAML.load(@request.cookies["play_story"]) if @request.cookies["play_story"]
  end

  def game
    @request.session[:game]
  end

  def respond
    @request.session[:respond]
  end

  def hint
    @request.session[:hint]
  end

  def error
    @request.session[:error]
  end

  def formated_respond
    ' + ' * respond[0] + ' - ' * respond[1]
  end

  def formated_hint
    hint.map{|x| x || '*'}
  end

  def place
    table = leaderboards
    place = 1
    p table
    table.each do |x|
      if game.score > x[2]
        break
      else
        place += 1
      end
    end
    place
  end
end
