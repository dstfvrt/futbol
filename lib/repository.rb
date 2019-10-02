require "csv"

class Repository
  attr_reader :filepath, :record_class
  def initialize(filepath, record_class)
    @filepath = filepath
    @record_class = record_class
  end

  def records
    CSV.open(filepath, headers: true, header_converters: :symbol).each.to_a
  end
end
