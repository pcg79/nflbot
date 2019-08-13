require 'sinatra/base'

module SlackNFLBot
  class Web < Sinatra::Base
    get '/' do
      'Slack integration for NFL fun, https://github.com/pcg79/nflbot'
    end
  end
end
