class StaticPagesController < ApplicationController
  def home
    @records = LeaderboardRecord.all
    render("index.html.erb")
  end
end
