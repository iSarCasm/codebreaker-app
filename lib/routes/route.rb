class Route
  attr_reader :controller, :action

  def initialize(route)
    @controller = route.split('#').first
    @action     = route.split('#').last
  end

  def controller_name
    "#{capitalize(controller)}Controller"
  end

  private

  def capitalize(string)
    string.split('_').map do |c|
      c.capitalize
    end.join
  end
end
