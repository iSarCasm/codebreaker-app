class Route
  attr_reader :controller, :action

  def initialize(route)
    @controller = route.split('#').first
    @action     = route.split('#').last
  end

  def invoke(request)
    Object.const_get(controller_name).new(request).send(action)
  end

  private

  def controller_name
    "#{capitalize(controller)}Controller"
  end

  def capitalize(string)
    string.split('_').map do |c|
      c.capitalize
    end.join
  end
end
