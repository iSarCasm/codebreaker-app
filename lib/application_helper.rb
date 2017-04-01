module ApplicationHelper
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
