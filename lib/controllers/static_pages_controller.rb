class StaticPagesController < ApplicationController
  def home
    @records = LeaderboardRecord.all
    render 'index'
  end
end
