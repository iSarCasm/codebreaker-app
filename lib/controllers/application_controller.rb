class ApplicationController < Controller::Base
  DB_PATH = "db/records.yml"
  PLAY_COOKIE = "play_story"

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
end
