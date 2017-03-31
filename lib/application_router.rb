class ApplicationRouter
  attr_reader :request, :controller

  def initialize(request:, controller:)
    @request    = request
    @controller = controller.new(request)
  end

  def route
    controller.send(get_controller_action)
  rescue RoutingError => e
    Rack::Response.new("Not Found", 404)
  end

  def get_controller_action
    case request.path
    when "/"            then :index_page
    when "/start_game"  then :start_game
    when "/play"        then :play_page
    when "/guess"       then :guess
    when "/hint"        then :get_hint
    when "/result"      then :result_page
    when "/record"      then :save_record
    else fail RoutingError
    end
  end
end
