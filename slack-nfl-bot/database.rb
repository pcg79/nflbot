require "sqlite3"

module SlackNFLBot
  class Database
    def self.database
      SQLite3::Database.new "db/#{ENV['RACK_ENV']}.db"
    end
  end
end
