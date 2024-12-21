#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo "$($PSQL "TRUNCATE teams, games")"

cat games.csv | while IFS=',' read YEAR ROUND WINNER OPPONENT W_GOALS O_GOALS
do
  if [[ $YEAR != year ]]
  then
    #get w team id
    WID="$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'")"
    if [[ -z $WID ]]
    then
      #if none insert
      W_INSERT_RESULT="$($PSQL "INSERT INTO teams(name) VALUES ('$WINNER')")"
      #get new w team id
      WID="$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'")"
    fi
  
    #get o team id
    OID="$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT'")"
    if [[ -z $OID ]]
    then
      #if none insert
      O_INSERT_RESULT="$($PSQL "INSERT INTO teams(name) VALUES ('$OPPONENT')")"
      #get new o team id
      OID="$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT'")"
    fi

    #insert game
    echo "$($PSQL "INSERT INTO games (year,round,winner_id,opponent_id,winner_goals,opponent_goals) VALUES ($YEAR,'$ROUND',$WID,$OID,$W_GOALS,$O_GOALS)")"
  fi
done