class StaticPagesController < ApplicationController
  include ApplicationHelper

  def home
    render("index.html.erb")
  end
end
