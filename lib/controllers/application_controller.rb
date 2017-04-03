class ApplicationController < Controller::Base
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
    LeaderboardRecord.all
  end
end
