require "sqlite3"

db = SQLite3::Database.new "production.db"

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

[
  "Arizona Cardinals",
  "Atlanta Falcons",
  "Baltimore Ravens",
  "Buffalo Bills",
  "Carolina Panthers",
  "Chicago Bears",
  "Cincinnati Bengals",
  "Cleveland Browns",
  "Dallas Cowboys",
  "Denver Broncos",
  "Detroit Lions",
  "Green Bay Packers",
  "Houston Texans",
  "Indianapolis Colts",
  "Jacksonville Jaguars",
  "Kansas City Chiefs",
  "Miami Dolphins",
  "Minnesota Vikings",
  "New England Patriots",
  "New Orleans Saints",
  "New York Giants",
  "New York Jets",
  "Oakland Raiders",
  "Philadelphia Eagles",
  "Pittsburgh Steelers",
  "San Diego Chargers",
  "San Francisco 49ers",
  "Seattle Seahawks",
  "St. Louis Rams",
  "Tampa Bay Buccaneers",
  "Tennessee Titans",
  "Washington Redskins"
].each_with_index do |name, index|
  db.execute "insert into teams(id, name) values ( ?, ? )", [index, name]
end

# Preassign those we know
{
  "UF854AY1K" => "New England Patriots", # Alex McC
  "U1DKE050A" => "Philadelphia Eagles",  # Conor
  "U03JJTQMA" => "San Francisco 49ers",  # James
  "UH8001CUX" => "Green Bay Packers",    # Alistair
  "U0H3MGR0E" => "San Diego Chargers",   # Rory
  "U54SRH6MP" => "Houston Texans",       # Tamsin
}.each do |slack_user_id, team_name|
  db.execute "insert into employees_teams(slack_user_id, team_id) select ?, id from teams where name = ?", [slack_user_id, team_name]
end
