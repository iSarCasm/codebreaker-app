class ApplicationRouter
  attr_reader :request, :controller

  def initialize(request:, controller:)
    @request    = request
    @controller = controller.new(request)
  end

  def route
    case request.path
    when "/"            then controller.index_page
    when "/start_game"  then controller.start_game
    when "/play"        then controller.play_page
    when "/guess"       then controller.guess
    when "/hint"        then controller.get_hint
    when "/result"      then controller.result_page
    when "/record"      then controller.save_record
    else Rack::Response.new("Not Found", 404)
    end
  end
end
