# nflbot
Slack bot for assigning NFL teams

All the logic for this lives in nflbot.rb.  It's based off the [Slack Ruby Bot gem](https://github.com/slack-ruby/slack-ruby-bot).

It uses a simple sqlite databaes to hold the teams, team facts, and team -> employee relationship.

## Commands

```
nflbot what is my team
nflbot which's my team
nflbot which is my team
nflbot what team is mine
nflbot what team's mine
nflbot which team is mine
nflbot which team's mine
```

Any of these will tell you which team you were assigned. If you do not yet have an assigned team, it'll assign you one and *then* tell you which team is yours.

```
nflbot [anything] fact about my team [anything]
```

It'll tell you a random fact about your assigned team.  Again, if you do not have a team yet, it'll assign you one and *then* tell you a fact.

```
nflbot [anything] fact about <team name> [anything]
```

It'll tell you a random fact about \<team name\>.
