require "sqlite3"

db = SQLite3::Database.new "db/#{ENV['RACK_ENV']}.db"

[
  "Arizona Cardinals",
  "Atlanta Falcons",
  "Baltimore Ravens",
  "Buffalo Bills",
  "Carolina Panthers",
  "Chicago Bears",
  "Cincinnati Bengals",
  "Cleveland Browns",
  "Dallas Cowboys",
  "Denver Broncos",
  "Detroit Lions",
  "Green Bay Packers",
  "Houston Texans",
  "Indianapolis Colts",
  "Jacksonville Jaguars",
  "Kansas City Chiefs",
  "Los Angeles Chargers",
  "Los Angeles Rams",
  "Miami Dolphins",
  "Minnesota Vikings",
  "New England Patriots",
  "New Orleans Saints",
  "New York Giants",
  "New York Jets",
  "Oakland Raiders",
  "Philadelphia Eagles",
  "Pittsburgh Steelers",
  "San Francisco 49ers",
  "Seattle Seahawks",
  "Tampa Bay Buccaneers",
  "Tennessee Titans",
  "Washington Redskins"
].each_with_index do |name, index|
  db.execute "insert into teams(id, name) values ( ?, ? )", [index+1, name]
end; nil

# Preassign those we know
{
  "UF854AY1K" => "New England Patriots", # Alex McC
  "U1DKE050A" => "Philadelphia Eagles",  # Conor
  "U03JJTQMA" => "San Francisco 49ers",  # James
  "UH8001CUX" => "Green Bay Packers",    # Alistair
  "U0H3MGR0E" => "San Diego Chargers",   # Rory
  "U54SRH6MP" => "Houston Texans",       # Tamsin
  "U59A582VA" => "Washington Redskins",  # Pat
}.each do |slack_user_id, team_name|
  db.execute "insert into employees_teams(slack_user_id, team_id) select ?, id from teams where name = ?", [slack_user_id, team_name]
end; nil

{
  "Arizona Cardinals" => [
    "The Arizona Cardinals had the longest postseason victory drought in NFL history (1947 to 1998).",
  ],
  "Atlanta Falcons" => [
    "The Atlanta Falcons were born in 1965 as an NFL expansion team, which the league awarded to Atlanta-based insurance executive Rankin Smith for $8.5 million. At the time, this was the highest sum that had ever been paid for a professional sports franchise. (By comparison, in 2008 the Miami Dolphins were purchased for $1 billion. How times have changed.)",
    "The Falcons' red and black color scheme is an homage to the college team Georgia Bulldogs.",
  ],
  "Baltimore Ravens" => [
    "In 1984 the Baltimore Colts moved to Indianapolis and became the Indianapolis Colts. Then in 1996 the Cleveland Browns moved to Baltimore to become the Baltimore Ravens. Finally, a new Cleveland Browns team debuted in 1999.",
  ],
  "Buffalo Bills" => [
    "The Bills have the distinction of being the only New York team that actually plays in New York. The Giants and Jets play at MetLife Stadium in New Jersey.",
  ],
  "Carolina Panthers" => [
    "The nicknames “Cobras,” “Rhinos,” and “Cougars” were all considered before franchise owner Jerry Richardson settled on “Panthers” at the suggestion of his son Mark, who’d always liked the big, black cats.",
  ],
  "Chicago Bears" => [
    "The NFL and the Chicago Bears were named on the same day. Both changed on June 24, 1922, the NFL from the American Professional Football Association and the Bears from the Chicago Staleys.",
    "The Chicago Bears have the most retired numbers of any NFL team with 13.",
    "George Halas retired as coach of the Chicago Bears four times in total.",
  ],
  "Cincinnati Bengals" => [
    "The Cincinnati Bengals franchise was granted on May 23rd, 1967.",
    "The Cincinnati Bengals won the AFC Championships in 1981 and in 1988.",
    "The team colors for the Cincinnati Bengals are black, orange, and white. The original team uniform was modeled after Paul Brown's former employer's team the Cleveland Browns. When Paul was fired by Art Model, the owner of the Cleveland Browns, Paul took all the equipment with him because he owned it. He then used it with his new team the Cincinnati Bengals.",
    "The team mascot for the Cincinnati Bengals is Who Dey, a Bengal tiger.",
  ],
  "Cleveland Browns" => [
    "In 1984 the Baltimore Colts moved to Indianapolis and became the Indianapolis Colts. In 1996 the Cleveland Browns moved to Baltimore to become the Baltimore Ravens. A new Cleveland Browns team debuted in 1999.",
  ],
  "Dallas Cowboys" => [
    "Emmitt Smith ran for more than 18,000 yards in his 15-year career, more than any other player in history. After his retirement, he went on to win the third Dancing with the Stars competition.",
  ],
  "Denver Broncos" => [
    "The Denver Broncos team mascots are Thunder II (a live horse) and Miles (the costume).",
    "The television show South Park creators Matt Stone and Trey Parker grew up as Denver Bronco fans and often mention the team on their cartoon.",
  ],
  "Detroit Lions" => [
    "The Detroit Lions' team colors are Honolulu blue, silver, black, and white.",
    "The mascot of the Detroit Lions' is Roary the Lion.",
    "The Detroit Lions were originally called the Portsmouth Spartans, and were based in Portsmouth, Ohio, but after joining the NFL in 1930, it wasn't possible to remain in Portsmouth due to the Great Depression.",
  ],
  "Green Bay Packers" => [
    "The Green Bay Packers won the first Super Bowl ever played, which was held in Los Angeles in January 1967.",
    "Only one team has ever won three NFL championships in a row and it wasn’t during the Super Bowl era. That team was the Vince Lombardi-coached Green Bay Packers between 1966 and 1968.",
  ],
  "Houston Texans" => [
    "The Houston Texans were established in 2002 as an NFL expansion team after the previous NFL franchise the Houston Oilers moved to Tennessee and became the Tennessee Titans.",
    "The mascot of the Houston Texans is Toro, and their team fight song is Bulls on Parade.",
  ],
  "Indianapolis Colts" => [
    "In 1984 the Baltimore Colts moved to Indianapolis and became the Indianapolis Colts. In 1996 the Cleveland Browns moved to Baltimore to become the Baltimore Ravens. A new Cleveland Browns team debuted in 1999.",
    "The Indianapolis Colts won 23-straight regular-season games in 2008 and 2009.",
  ],
  "Jacksonville Jaguars" => [
    "Founded in 1993, the Jaguars first joined the NFL as an expansion team during the 1995 season.",
    "After posting a 4–12 record in their inaugural 1995 season, the Jaguars went 9–7 and earned a spot in the AFC playoffs the following season behind the standout play of quarterback Mark Brunell and wide receiver Jimmy Smith.",
  ],
  "Kansas City Chiefs" => [
    "The Chiefs have an actual horse mascot named Warpaint."
  ],
  "Los Angeles Chargers" => [
    "The Los Angeles Chargers’ existence began in the AFL back in 1960. The team moved to San Diego the very next season, and then in 2016 moved back to Los Angeles after a 56-year hiatus."
  ],
  "Los Angeles Rams" => [
    "The Los Angeles Rams were established in Cleveland as the Cleveland Rams and played there from 1936 to 1945.",
    "In 1945, the Los Angeles Rams left Cleveland for Los Angeles.  They stayed in LA until 1994 when they moved to St. Louis.",
    "In 1995, the Los Angeles Rams moved from LA to St. Louis.  They stayed in St. Louis until 2015 at which point they moved _back_ to LA.",
  ],
  "Miami Dolphins" => [
    "Don Shula, who coached with the Baltimore Colts and the Miami Dolphins, won 347 games in his career. That's more than any other coach in NFL history. He was inducted into the Hall of Fame in 1997.",
    "The Dolphins are the only team in NFL history to go undefeated through the regular season and the postseason. It happened back in 1972, but don’t worry — Dolphins fans are still more than happy to brag about it.",
  ],
  "Minnesota Vikings" => [
    "During the 1998 season the Vikings led by Randall Cunningham, Robert Smith, Cris Carter, and rookie Randy Moss, never scored less than 24 points in any of their games (that's a lot of points).",
  ],
  "New England Patriots" => [
    "The Patriots have won six Super Bowls in team history — most in the NFL — and they’ve won every single one of them in the Tom Brady-Bill Belichick era.",
    "The New England Patriots set an NFL record by throwing just four interceptions total in 2010 (all by Tom Brady, obviously). In that season, there were 15 occasions when a team threw four interceptions in a single game.",
  ],
  "New Orleans Saints" => [
    "The New Orleans Saints were founded in 1967 by John W. Mecom Jr. and David Dixon.",
    "It took the New Orleans Saints 32 years to win their first playoff game.",
    "In August 2005 Hurricane Katrina caused extensive damage to the Saints home stadium - the Superdome. The Saints had to move the rest of their games to other stadiums. The Superdome was used for emergency shelter during the hurricane.",
  ],
  "Philadelphia Eagles" => [
    "The Philadelphia Eagles joined the National Football League in 1933.",
    "On October 22, 1939, the Eagles lost to the Brooklyn Football Dodgers (a club which no longer exists) by a final score of 23-14 in what was the very first televised NFL game.",
    "World War II created a massive player shortage, with many pro footballers leaving their teams to fight overseas. In Pennsylvania, the Steelers' and Eagles’ rosters were so heavily depleted that some feared both clubs would shut down. Instead, they merged. For the duration of the 1943 season, these two franchises consolidated their squads into one, 25-man team nicknamed the “Steagles.”",
  ],
  "Pittsburgh Steelers" => [
    "The Pittsburgh Steelers actually began as the Pittsburgh Pirates in 1933 before owner Art Rooney changed their name to the Steelers in 1940. In 1943, they became the \"Steagles\" when they were merged with the Philadelphia Eagles as football rosters became depleted during World War II. The next year (1944) saw them similiarly merged with the Cardinals, and they became the oh-so-exciting \"Card-Pitt\" team.",
    "Founded as the Pittsburgh Pirates by Art Rooney in 1933, the Steelers are the oldest franchise in the AFC and have remained in the hands of the Rooney family throughout.",
    "The golden era for the Pittsburgh Steelers was their four Super Bowl wins from the mid 1970s with a team built on the formidable defense that became known as ‘The Steel Curtain’. Terry Bradshaw was the quarterback for all four victories and was twice named Super Bowl MVP.",
  ],
  "San Francisco 49ers" => [
    "The San Francisco 49ers were founded, and joined the NFL, in 1949.",
    ""
  ],
  "Seattle Seahawks" => [
    "The Seattle Seahawks were originally owned by the Nordstrom family — yes, the same family who owned the upscale department store. When the Seahawks won the Super Bowl in 2014, the team classily presented John Nordstrom with a Super Bowl ring.",
    "When the Seahawks were created, a “name the team” contest received 20,365 entries and 1,742 different names.",
  ],
  "Tampa Bay Buccaneers" => [
    "The Tampa Bay Buccaneers were established in 1974 then joined the NFL in 1976 as an expansion team, along with the Seattle Seahawks.",
    "The Tampa Bay Buccaneers are owned by the Glazer family who also own Manchester United.",
  ],
  "Tennessee Titans" => [
    "The Tennessee Titans used to be known as the Houston Oilers, and played in Houston, Texas.  The Oilers were founded in 1960 as a charter member of the American Football League.",
    "The Tennessee Titans moved from Texas to Tennessee in 1997 and played in Memphis for one season before moving to Nashville. For two seasons, the team was known as the Tennessee Oilers before changing its name to the Titans in 1999.",
  ],
  "Washington Redskins" => [
    "Art Monk held the single-season reception record (106) for eight years. Since it was broken in 1992, it has been surpassed more than 40 times.",
  ]
}.each do |name, facts_array|
  facts_array.each do |fact|
    db.execute "insert into teams_facts(team_id, fact) select id, ? from teams where name = ?", [fact, name]
  end
end; nil
