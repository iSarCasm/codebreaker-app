class LeaderboardRecord < FileStorage
  attr_reader :place, :name, :score

  def self.storage_path
    'db/records.yml'
  end

  def self.all
    super.sort do |a1, a2|
      a1.score <=> a2.score
    end
  end

  def initialize(name: , score:)
    @name   = name
    @score  = score
  end

  def place
    if all.empty?
      1
    else
      all.each.with_index do |record, place|
        return place+1 if score > record.score
      end
    end
  end
end
