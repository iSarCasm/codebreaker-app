class ApplicationRouter
  attr_reader :request, :response, :controller

  def initialize(request:, controller:)
    @request    = request
    @response   = response
    @controller = controller
  end

  def respond
    controller.call route: Route.new(route), request: request
  rescue RoutingError => e
    Rack::Response.new("Not Found", 404)
  end

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

  private

  def route
    if routes.include? request.path
      routes[request.path]
    else
      fail RoutingError
    end
  end
end
