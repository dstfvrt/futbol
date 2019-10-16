class Team
  attr_reader :database
  
  def initialize(attributes)
    @attributes = attributes
    @database = attributes[:database]
  end

  def team_id
    @attributes[:team_id].to_i
  end

  def franchise_id
    @attributes[:franchiseId].to_i
  end

  def team_name
    @attributes[:teamName]
  end

  def abbreviation
    @attributes[:abbreviation]
  end

  def stadium
    @attributes[:Stadium]
  end

  def link
    @attributes[:link]
  end
end
