$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require_relative '../lib/racker'
require 'rack/test'

ENV['RACK_ENV'] = 'test'
TEST_ENV = Hash.new
