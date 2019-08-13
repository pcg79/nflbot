class Fact < Base
  class << self

    def find_facts(team_name)
      rows = database.execute <<-SQL
        select fact from teams_facts tf join teams t
          on tf.team_id = t.id
          where lower(t.name) like lower('%#{team_name}%')
      SQL

      rows.first
    end

    def say_fact(client, team, facts, channel)
      if facts
        client.say(text: "Here's a fun fact about the *#{team}*: #{facts.sample}", channel: channel)
      else
        client.say(text: "I don't have any facts about the *#{team}* :cry:", channel: data.channel)
      end
    end

  end
end
