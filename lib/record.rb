class Record
  attr_reader :attributes, :database

  def initialize(attributes)
    @attributes = attributes
    @database = attributes[:database]
  end
end
