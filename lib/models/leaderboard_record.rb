class LeaderboardRecord < FileStorage
  attr_reader :place, :name, :score

  def self.storage_path
    'db/records.yml'
  end

  def self.all
    super.sort do |a1, a2|
      a2.score <=> a1.score
    end
  end

  def initialize(name: 'Guest', score:)
    @name   = name
    @score  = score
  end

  def place
    if all.empty?
      return 1
    else
      all.each.with_index do |record, place|
        return place+1 if score >= record.score
      end
    end
  end
end
