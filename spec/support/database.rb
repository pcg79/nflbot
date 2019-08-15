raise "Don't run outside of test env!" unless ENV['RACK_ENV'] == "test"

require_relative "../../slack-nfl-bot/database"

db = SlackNFLBot::Database.database

db.drop_table :teams_facts
db.drop_table :employees_teams
db.drop_table :teams

require_relative "../../db/migrate.rb"

[
  "Washington Redskins"
].each_with_index do |name, index|
  teams = db[:teams]
  teams.insert(id: index+1, name: name)
end; nil

{
  "Washington Redskins" => [
    "Art Monk held the single-season reception record (106) for eight years. Since it was broken in 1992, it has been surpassed more than 40 times.",
  ]
}.each do |name, facts_array|
  facts_array.each do |fact|
    teams_facts = db[:teams_facts]
    teams = db[:teams]
    teams_facts.insert(team_id: teams.where(name: name).get(:id), fact: fact)
  end
end; nil
