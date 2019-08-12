$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..'))

require 'slack-ruby-bot/rspec'
require 'vcr_helper'

Dir[File.join(File.dirname(__FILE__), 'support', '**/*.rb')].each do |file|
  require file
end

VCR.use_cassette('nflbot') do
   require 'nflbot'
end
