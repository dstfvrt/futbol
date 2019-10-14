require "csv"

class Repository
  attr_reader :filepath, :record_class, :records
  def initialize(filepath, record_class)
    @filepath = filepath
    @record_class = record_class
    @records = []
    make_records
  end

  def make_records
    records = CSV.open(filepath, headers: true, header_converters: :symbol)
      .map do |record|
      record_class.new(record)
    end
  end
end
