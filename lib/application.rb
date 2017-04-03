require 'rack'
require 'erb'
require 'codebreaker'
require 'yaml'
require 'pry'

require_relative 'routes/exceptions/routing_error'
require_relative 'routes/route'
require_relative 'routes/router'
require_relative 'routes/application_router'

require_relative 'application_helper'

require_relative 'controllers/controller'
require_relative 'controllers/application_controller'
require_relative 'controllers/game_controller'
require_relative 'controllers/static_pages_controller'

class Application
  def self.call(env)
      ApplicationRouter.new(
        request: request,
        controller: Controller
      ).respond
  end

  def request
    @@request ||= Rack::Request.new(env)
  end
end
