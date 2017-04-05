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

    def session
      request.session
    end

    def params
      request.params
    end

    def render(template)
      rendered =  render_layout do
                    render_partial(template)
                  end
      response.body << rendered
    end

    def render_partial(partial)
      partial_path = File.expand_path("../../views/#{partial}", __FILE__)
      ERB.new(File.read(partial_path)).result(binding)
    end

    def render_layout(layout: 'application.html.erb')
      layout_path = File.expand_path("../../views/#{layout}", __FILE__)
      ERB.new(File.read(layout_path)).result(binding)
    end

    def redirect where
      response.redirect where
    end
  end
end
