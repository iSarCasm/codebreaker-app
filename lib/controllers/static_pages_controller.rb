class StaticPagesController < ApplicationController::Base
  include ApplicationHelper

  def home
    Rack::Response.new(render("index.html.erb"))
  end
end
