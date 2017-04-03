class ApplicationController < Controller::Base
  def error
    session[:error]
  end
end
