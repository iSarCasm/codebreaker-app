require_relative '../lib/racker'
require 'rack/test'
require 'capybara/rspec'
require 'pry'

ENV['RACK_ENV'] = 'test'
TEST_ENV = Hash.new

class Racker
  DB_PATH = File.expand_path("../fixtures/#{DB_PATH}", __FILE__)
end

Capybara.register_driver :rack_test do |app|
  Capybara::RackTest::Driver.new(Racker, headers: { 'HTTP_USER_AGENT' => 'Capybara' })
end
