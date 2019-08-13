$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'slack-nfl-bot'
require 'web'

Thread.new do
  begin
    SlackNFLBot::App.instance.run
  rescue Exception => e
    STDERR.puts "ERROR: #{e}"
    STDERR.puts e.backtrace
    raise e
  end
end

run SlackNFLBot::Web
