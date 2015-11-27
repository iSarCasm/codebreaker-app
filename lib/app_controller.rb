class Racker
  def index_page
    Rack::Response.new(render("index.html.erb"))
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

  def play_page
    Rack::Response.new(render("play.html.erb"))
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

  def result_page
    Rack::Response.new(render("result.html.erb"))
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
end
