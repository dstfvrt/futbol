RSpec.describe Repository do
  describe "#initialize" do
    it "takes in a filepath and a record_class" do
      filepath = "./spec/fixtures/teams.csv"
      record_class = Team

      repository = Repository.new(filepath, record_class)

      expect(repository.filepath).to eq filepath
      expect(repository.record_class).to eq record_class
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
  end
end
