module ApplicationController
  def self.call(route:, request:)
    route.invoke(request)
  end

  class Base
    def initialize(request)
      @request = request
    end
  end
end
