require "csv"

class Repository
  attr_reader :filepath, :record_class, :database

  def initialize(filepath, record_class, database = nil)
    @filepath = filepath
    @record_class = record_class
    @database = database
  end

  def records
    CSV.open(filepath, csv_options).map do |record_attributes|
      record_attributes[:database] = database
      record_class.new(record_attributes)
    end
  end

  private

  def csv_options
    {
      headers: true,
      header_converters: :symbol,
    }
  end
end
