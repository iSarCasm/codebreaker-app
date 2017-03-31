require 'rack'
require 'erb'
require 'codebreaker'
require  'yaml'
require 'pry'

require_relative 'application_helper'
require_relative 'application_controller'

module Application
  def self.call(env)
    request = Rack::Request.new(env)
    controller = ApplicationController.new(request)
    route(request, controller)
  end

  private

  def self.route(request, controller)
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
