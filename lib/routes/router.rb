class Router
  attr_reader :request, :controller

  def initialize(request:, controller:)
    @request    = request
    @controller = controller
  end

  def respond
    controller.call route: Route.new(route), request: request
  rescue RoutingError => e
    not_found
  end

  def routes
    Hash.new
  end

  def not_found
    Rack::Response.new("Not Found", 404)
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
