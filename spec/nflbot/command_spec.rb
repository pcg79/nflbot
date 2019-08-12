require 'spec_helper'

describe NFLBot do
  def app
    NFLBot.instance
  end

  it "assigns a team" do
    expect(message: "nflbot what's my team", channel: 'channel').to respond_with_slack_message('4')
  end

end
