class Base

  def json_data(endpoint=nil)
    endpoint ||= self.class.json_endpoint
    JSON.load(open(endpoint))
  end

  class << self
    def slack_user_id(data)
      data.user
    end

    def database
      SlackNFLBot::Database.database
    end
  end
end
