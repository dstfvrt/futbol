require "csv"

class Repository
  attr_reader :filepath, :record_class
  def initialize(filepath, record_class)
    @filepath = filepath
    @record_class = record_class
  end

  def records
    CSV.open(filepath, headers: true, header_converters: :symbol)
      .map do |record|
      record_class.new(record)
    end
  end
end
