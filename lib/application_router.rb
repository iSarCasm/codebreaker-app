class ApplicationRouter
  attr_reader :request, :controller

  def initialize(request:, controller:)
    @request    = request
    @controller = controller
  end

  def route
    controller.call route: Route.new(routing_rules), request: request
  rescue RoutingError => e
    Rack::Response.new("Not Found", 404)
  end

  def routing_rules
    case request.path
    when "/"            then 'static_pages#home'
    when "/start_game"  then 'game#start_game'
    when "/play"        then 'game#play_page'
    when "/guess"       then 'game#guess'
    when "/hint"        then 'game#get_hint'
    when "/result"      then 'game#result_page'
    when "/record"      then 'game#save_record'
    else fail RoutingError
    end
  end
end
