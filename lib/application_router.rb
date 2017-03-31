class ApplicationRouter < Router
  def routes
    {
      "/"            => 'static_pages#home',
      "/start_game"  => 'game#start_game',
      "/play"        => 'game#play_page',
      "/guess"       => 'game#guess',
      "/hint"        => 'game#get_hint',
      "/result"      => 'game#result_page',
      "/record"      => 'game#save_record'
    }
  end

  def not_found
    Rack::Response.new("Not Found", 404)
  end
end
