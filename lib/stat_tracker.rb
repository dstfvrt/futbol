require "csv"
require "pry"
class StatTracker
  def initialize
  end

  def self.from_csv(locations)
    locations.each do |location|
      CSV.foreach(location[1]) do |row|
        puts row
      end
    end
  end
end
