class ApplicationController < Controller::Base
  # There could be some methods which need to be shared between all controllers
  def error
    session[:error]
  end
end
