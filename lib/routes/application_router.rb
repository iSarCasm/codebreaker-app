class ApplicationRouter < Router
  def routes
    {
      "/"            => 'static_pages#home',
      "/start_game"  => 'game#start',
      "/play"        => 'game#play',
      "/guess"       => 'game#guess',
      "/hint"        => 'game#hint',
      "/result"      => 'game#result',
      "/record"      => 'game#save_record'
    }
  end

  def not_found
    Rack::Response.new("Not Found", 404)
  end
end
