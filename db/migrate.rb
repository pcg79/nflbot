require_relative "../slack-nfl-bot/database"

db = SlackNFLBot::Database.database

unless db.table_exists?(:teams)
  db.create_table :teams do
    primary_key :id

    column :name, String
  end
end

unless db.table_exists?(:employees_teams)
  db.create_table :employees_teams do
    column :slack_user_id, String
    column :team_id, Integer
  end
end

unless db.table_exists?(:teams_facts)
  db.create_table :teams_facts do
    column :team_id, Integer
    column :fact, String
  end
end
