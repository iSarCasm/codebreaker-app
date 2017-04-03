class ApplicationController < Controller::Base
  def game
    session[:game]
  end

  def respond
    session[:respond]
  end

  def error
    session[:error]
  end
end
