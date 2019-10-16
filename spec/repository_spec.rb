require "./lib/repository"
require "./lib/team"

RSpec.describe Repository do
  describe "#initialize" do
    it "takes in a filepath and a record_class" do
      filepath = "./spec/fixtures/teams.csv"
      record_class = Team

      repository = Repository.new(filepath, record_class)

      expect(repository.filepath).to eq filepath
      expect(repository.record_class).to eq record_class
    end

    it "takes in an optional database" do
      filepath = "./spec/fixtures/teams.csv"
      record_class = Team
      database = double("database")
      repository = Repository.new(filepath, record_class, database)

      expect(repository.database).to eq database
    end
  end

  describe "#records" do
    it "returns converted records from the CSV's data" do
      filepath = "./spec/fixtures/teams.csv"
      record_class = Team

      repository = Repository.new(filepath, record_class)

      expect(repository.records.count).to eq 32
      expect(repository.records.first).to be_kind_of Team
    end

    context "when it has a database" do
      it "passes it to the records it creates" do
        filepath = "./spec/fixtures/teams.csv"
        record_class = Team
        database = double("database")
        repository = Repository.new(filepath, record_class, database)

        expect(repository.records.all? { |record| record.database == database })
          .to eq true
      end
    end
  end

  describe "#"
end
