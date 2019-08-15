# require "sqlite3"
# require "pg"
require 'sequel'

module SlackNFLBot
  class Database
    def self.database
      # SQLite3::Database.new "db/#{ENV['RACK_ENV']}.db"
      # PG.connect( dbname: "nflbot_#{ENV['RACK_ENV']}" )
      Sequel.connect(adapter: :postgres, database: "nflbot_#{ENV['RACK_ENV']}")
    end
  end
end
