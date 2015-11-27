require "erb"
require "codebreaker"
require 'yaml'

require_relative "app_helper"
require_relative "app_controller"

class Racker
  def self.call(env)
    new(env).response.finish
  end

  def initialize(env)
    @request = Rack::Request.new(env)
  end

  def response
    case @request.path
    when "/"            then index_page
    when "/start_game"  then start_game
    when "/play"        then play_page
    when "/guess"       then guess
    when "/hint"        then get_hint
    when "/result"      then result_page
    when "/record"      then save_record
    else Rack::Response.new("Not Found", 404)
    end
  end

  def render(template)
    path = File.expand_path("../views/#{template}", __FILE__)
    ERB.new(File.read(path)).result(binding)
  end

  def clear_session
    @request.session.clear
  end

  def clear_cookies(response)
    response.delete_cookie("play_story")
  end

  def add_play_history(response, add)
    if @request.cookies["play_story"]
      history = YAML.load(@request.cookies["play_story"])
      history << add
    else
      history = [add]
    end
    history = YAML.dump(history)
    response.set_cookie("play_story", history)
  end
end
