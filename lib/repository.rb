require "csv"

class Repository
  attr_reader :filepath, :record_class, :database, :records

  def initialize(filepath, record_class, database = nil)
    @filepath = filepath
    @record_class = record_class
    @database = database
    @records = build_records
  end

  private

  def build_records
    CSV.open(filepath, csv_options).map do |record_attributes|
      record_attributes[:database] = database
      record_class.new(record_attributes)
    end
  end

  def csv_options
    {
      headers: true,
      header_converters: :symbol,
    }
  end
end
