$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..'))

ENV['RACK_ENV'] = 'test'

require 'slack-ruby-bot/rspec'
require 'pry'

Dir[File.join(File.dirname(__FILE__), 'support', '**/*.rb')].each do |file|
  require file
end

require 'slack-nfl-bot'
