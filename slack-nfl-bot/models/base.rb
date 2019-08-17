class Base
  class << self

    def slack_user_id(data)
      data.user
    end

    def database
      SlackNFLBot::Database.database
    end

  end
end
