require "./lib/record"

RSpec.describe Record do
  describe "#initialize" do
    it "takes attributes" do
      attributes = { database: nil }
      record = Record.new(attributes)

      expect(record).to be_kind_of Record
    end
  end

  describe "#attributes" do
    it "returns a hash" do
      attributes = { database: nil }
      record = Record.new(attributes)

      expect(record.attributes).to be_kind_of Hash
    end
  end

  describe "#database" do
    it "returns a database" do
      database = double("Database")
      attributes = { database: database }
      record = Record.new(attributes)

      expect(record.database).to eq database
    end
  end
end
