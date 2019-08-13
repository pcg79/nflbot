require "sqlite3"

db = SQLite3::Database.new "db/#{ENV['RACK_ENV']}.db"

db.execute <<-SQL
  create table teams (
    id int,
    name varchar(50)
  );
SQL

db.execute <<-SQL
  create table employees_teams (
    slack_user_id varchar(20),
    team_id int
  );
SQL

db.execute <<-SQL
  create table teams_facts (
    team_id int,
    fact text
  );
SQL
