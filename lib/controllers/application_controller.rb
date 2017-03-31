class ApplicationController < Controller::Base
  DB_PATH = "db/records.yml"

  def game
    session[:game]
  end

  def respond
    session[:respond]
  end

  def hint
    session[:hint]
  end

  def error
    session[:error]
  end

  def play_history
    session[:play_history]
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
