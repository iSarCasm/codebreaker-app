require 'rack'
require 'erb'
require 'codebreaker'
require 'yaml'
require 'pry'

require_relative 'routes/exceptions/routing_error'
require_relative 'routes/route'
require_relative 'routes/router'
require_relative 'routes/application_router'

require_relative 'models/storages/storage'
require_relative 'models/storages/file_storage'
require_relative 'models/storages/session_storage'
require_relative 'models/attempt'
require_relative 'models/guess_attempt'
require_relative 'models/hint_attempt'
require_relative 'models/leaderboard_record'

require_relative 'controllers/controller'
require_relative 'controllers/application_controller'
require_relative 'controllers/game_controller'
require_relative 'controllers/static_pages_controller'

class Application
  def self.call(env)
    @@env = env
    @@request = Rack::Request.new(@@env)
    ApplicationRouter.new(
      request: request,
      controller: Controller
    ).respond
  end

  def self.request
    @@request
  end
end
