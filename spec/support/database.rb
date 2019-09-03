raise "Don't run outside of test env!" unless ENV['RACK_ENV'] == "test"

require_relative "../../slack-nfl-bot/database"

db = SlackNFLBot::Database.database

db.drop_table :teams_facts
db.drop_table :employees_teams
db.drop_table :teams

require_relative "../../db/migrate.rb"

[
  "Atlanta Falcons",
  "Washington Redskins",
].each_with_index do |name, index|
  teams = db[:teams]
  teams.insert(id: index+1, name: name)
end; nil

{
  "1" => "Washington Redskins",
  "2" => "Washington Redskins",
  "3" => "Atlanta Falcons"
}.each do |slack_user_id, team_name|
  employees_teams = db[:employees_teams]
  teams = db[:teams]
  employees_teams.insert(slack_user_id: slack_user_id, team_id: teams.where(name: team_name).get(:id))
end; nil

{
  "Washington Redskins" => [
    "Redskins fact!",
  ]
}.each do |name, facts_array|
  facts_array.each do |fact|
    teams_facts = db[:teams_facts]
    teams = db[:teams]
    teams_facts.insert(team_id: teams.where(name: name).get(:id), fact: fact)
  end
end; nil
