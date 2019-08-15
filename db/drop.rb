require_relative "../slack-nfl-bot/database"

db = SlackNFLBot::Database.database

db.drop_table :teams_facts
db.drop_table :employees_teams
db.drop_table :teams
