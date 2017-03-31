require 'rack'
require 'erb'
require 'codebreaker'
require 'yaml'
require 'pry'

require_relative '_engine/exceptions/routing_error'
require_relative '_engine/route'
require_relative '_engine/controller'

require_relative 'application_router'
require_relative 'application_helper'

require_relative 'controllers/application_controller'
require_relative 'controllers/game_controller'
require_relative 'controllers/static_pages_controller'

module Application
  def self.call(env)
      ApplicationRouter.new(
        request: Rack::Request.new(env),
        controller: Controller
      ).respond
  end
end
