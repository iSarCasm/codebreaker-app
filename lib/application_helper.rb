module ApplicationHelper
  def game
    @request.session[:game]
  end

  def respond
    @request.session[:respond]
  end

  def hint
    @request.session[:hint]
  end

  def error
    @request.session[:error]
  end

  def formated_respond
    '+ ' * respond[0] + '- ' * respond[1]
  end

  def formated_hint
    hint.map{|x| x || '*'}
  end

  def place
    table = leaderboards
    place = 1
    table.each do |x|
      if game.score > x[2]
        break
      else
        place += 1
      end
    end
    place
  end
end
