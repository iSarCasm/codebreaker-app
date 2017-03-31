require 'rack'
require 'erb'
require 'codebreaker'
require  'yaml'
require 'pry'

require_relative 'application_router'
require_relative 'application_helper'
require_relative 'application_controller'

module Application
  def self.call(env)
    ApplicationRouter.new(
      request: Rack::Request.new(env),
      controller: ApplicationController
    ).route
  end
end
