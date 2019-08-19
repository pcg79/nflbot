class Base

  def xml_data
    XML::Document.string(open(self.class.endpoint).read)
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
