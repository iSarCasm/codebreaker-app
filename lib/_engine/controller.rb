module Controller
  def self.call(route:, request:)
    Rack::Response.new do |response|
      run_action_for_controller(route, request, response)
    end
  end

  def self.run_action_for_controller(route, request, response)
    Object.const_get(route.controller_name).new(request, response).send(route.action)
  end

  class Base
    attr_reader :request, :response

    def initialize(request, response)
      @request = request
      @response = response
    end

    def render(template)
      path = File.expand_path("../../views/#{template}", __FILE__)
      response.body << ERB.new(File.read(path)).result(binding)
    end

    def session
      request.session
    end

    def redirect where
      response.redirect where
    end
  end
end
