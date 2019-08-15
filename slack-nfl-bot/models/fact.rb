class Fact < Base
  class << self

    def find_fact(team_name)
      teams_facts = database[:teams_facts]
      teams_facts.join(:teams, id: :team_id)
        .where(
          Sequel.like(:name, "%#{team_name}%", case_insensitive: true)
        )
        .order(Sequel.lit('RANDOM()'))
        .get(:fact)
    end

    def say_fact(client, team, fact, channel)
      team = team.split(/(\W)/).map(&:capitalize).join

      if fact && !fact.empty?
        client.say(text: "Here's a fun fact about the *#{team}*: #{fact}", channel: channel)
      else
        client.say(text: "I don't have any facts about the *#{team}* :cry:", channel: channel)
      end
    end

  end
end
