RSpec.configure do |config|
  config.before do
    SlackRubyBot.config.user = 'nflbot'
  end
end
