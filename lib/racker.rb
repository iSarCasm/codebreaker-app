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
      @request.session[:game] = Codebreaker::Game.new
      game.start(@request.params["diff"].to_sym)
      response.redirect("/play")
    end
  end

  def guess
    Rack::Response.new do |response|
      code = @request.params["code"].split("").map{|x| x.to_i(16)}
      @request.session[:respond] = game.guess(code)
      if game.state == :playing
        response.redirect("/play")
      else
        response.redirect("/result")
      end
    end
  end

  def get_hint
    Rack::Response.new do |response|
      @request.session[:hint] = game.hint
      response.redirect("/play")
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
    @request.session[:game]     = nil
    @request.session[:respond]  = nil
    @request.session[:hint]     = nil
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

  def place
    table = leaderboards.reverse
    place = 1
    table.each_index do |x|
      if game.score > x[2]
        break
      else
        place += 1
      end
    end
    place
  end
end
