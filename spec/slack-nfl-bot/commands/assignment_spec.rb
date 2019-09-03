require 'spec_helper'

describe SlackNFLBot::Commands::Assignment do
  def app
    SlackNFLBot::App.new
  end

  # info.user.profile.real_name
  let(:pat) do
    OpenStruct.new(
      user: OpenStruct.new(
        profile: OpenStruct.new(
          real_name: "Pat"
        )
      )
    )
  end

  let(:ethan) do
    OpenStruct.new(
      user: OpenStruct.new(
        profile: OpenStruct.new(
          real_name: "Ethan"
        )
      )
    )
  end

  let(:kalani) do
    OpenStruct.new(
      user: OpenStruct.new(
        profile: OpenStruct.new(
          real_name: "Kalani"
        )
      )
    )
  end

  it "returns who was assigned which team" do
    expect_any_instance_of(SlackNFLBot::SlackClient).to receive(:user_info).and_return(pat, ethan, kalani)

    slack_message = "Atlanta Falcons: Pat\nWashington Redskins: Ethan, Kalani"
    expect(message: "nflbot assignments", channel: 'channel').to respond_with_slack_message(slack_message)
  end

end
