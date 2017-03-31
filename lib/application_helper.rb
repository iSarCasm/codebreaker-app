module ApplicationHelper
  DB_PATH = "db/records.yml"
  PLAY_COOKIE = "play_story"

  def play_cookies
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
    '+ ' * respond[0] + '- ' * respond[1]
  end

  def formated_hint
    hint.map{|x| x || '*'}
  end

  def leaderboards
    db = File.open(DB_PATH)
    loaded = YAML.load_stream(db)
    loaded.sort! do |x1, x2|
      x2[1] <=> x1[1]
    end
    loaded.map!.with_index do |x, i|
      x.insert(0, i+1)
    end
    loaded
  end

  def place
    table = leaderboards
    place = 1
    table.each do |x|
      if game.score > x[2]
        break
      else
        place += 1
      end
    end
    place
  end

  def render(template)
    path = File.expand_path("../views/#{template}", __FILE__)
    ERB.new(File.read(path)).result(binding)
  end

  def clear_game_cookies(response)
    response.delete_cookie(PLAY_COOKIE)
  end

  def add_play_cookie(response, add)
    if @request.cookies[PLAY_COOKIE]
      history = YAML.load(@request.cookies[PLAY_COOKIE])
      history << add
    else
      history = [add]
    end
    history = YAML.dump(history)
    response.set_cookie(PLAY_COOKIE, history)
  end
end
