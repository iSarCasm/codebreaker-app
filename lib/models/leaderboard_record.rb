class LeaderboardRecord < FileStorage
  attr_reader :place, :name, :score

  def self.storage_path
    'db/records.yml'
  end

  def self.all
    @@all ||= super.sort do |a1, a2|
      a2.score <=> a1.score
    end
  end

  def add
    @@all = nil
    super
  end

  def initialize(name: 'Guest', score:)
    @name   = name
    @score  = score
  end

  def place
    place = 1
    all.each.with_index do |record, record_place|
      return record_place + 1 if self == record
      return place if score > record.score
      place += 1
    end
    place
  end
end
