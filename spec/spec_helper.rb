require_relative '../lib/application'
require 'rack/test'
require 'capybara/rspec'
require 'pry'

require_relative 'fixtures/codebreaker_page_dsl'

ENV['RACK_ENV'] = 'test'
TEST_ENV = Hash.new

class Application
  DB_PATH = File.expand_path("../fixtures/#{DB_PATH}", __FILE__)
end


Capybara.register_driver :rack_test do |app|
  Capybara::RackTest::Driver.new(Application, headers: { 'HTTP_USER_AGENT' => 'Capybara' })
end
