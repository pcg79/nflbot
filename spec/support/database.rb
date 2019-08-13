raise "Don't run outside of test env!" unless ENV['RACK_ENV'] == "test"

require "sqlite3"

db = SQLite3::Database.new "db/test.db"

["teams", "employees_teams", "teams_facts"].each do |table|
  db.execute "drop table #{table}"
  rescue SQLite3::SQLException
end

require File.join(File.dirname(__FILE__), '..', '..', 'db', 'migrate.rb')

[
  "Washington Redskins"
].each_with_index do |name, index|
  db.execute "insert into teams(id, name) values ( ?, ? )", [index+1, name]
end; nil

{
  "Washington Redskins" => [
    "Art Monk held the single-season reception record (106) for eight years. Since it was broken in 1992, it has been surpassed more than 40 times.",
  ]
}.each do |name, facts_array|
  facts_array.each do |fact|
    db.execute "insert into teams_facts(team_id, fact) select id, ? from teams where name = ?", [fact, name]
  end
end; nil
