module SlackNFLBot
  class SlackClient
    def initialize
      Slack.configure do |config|
        config.token = ENV["SLACK_API_TOKEN"]
      end
    end

    def user_info(user_id)
      client.users_info(user: user_id)
    end

    private

    def client
      @client ||= Slack::Web::Client.new
    end
  end
end
