#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

#ask for input
echo "Enter your username:"
read USERNAME

#get user_id
USER_ID=$($PSQL "SELECT user_id FROM users WHERE user_name='$USERNAME'")

#find if the user exists or not
if [[ $USER_ID ]]
then
  #if username exist
  GAMES_PLAYED=$($PSQL "SELECT COUNT(*) FROM games WHERE user_id=$USER_ID")
  BEST_GAME=$($PSQL "SELECT MIN(tries) FROM games WHERE user_id=$USER_ID")
  echo "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
else
  #if username does not exist
  echo "Welcome, $USERNAME! It looks like this is your first time here."
fi


#generate secret number and store in variable
SECRET_NUMBER=$(($RANDOM % 1001 + 1))
echo "$SECRET_NUMBER"
echo "Guess the secret number between 1 and 1000:"
#loop asking for number guess
TRIES=0
while [[ $INPUT_NUMBER != $SECRET_NUMBER ]]
do
  read INPUT_NUMBER 
  if [[ ! $INPUT_NUMBER =~ ^-?[0-9]+$ ]]
  then
    #if not integer
    echo "That is not an integer, guess again:"
  elif [[ $INPUT_NUMBER -gt $SECRET_NUMBER ]]
  then
    #if highter than
    echo "It's lower than that, guess again:"
  elif [[ $INPUT_NUMBER -lt $SECRET_NUMBER ]]
  then
    #if lower than
    echo "It's higher than that, guess again:"
  fi
  #augment count
  TRIES=$(($TRIES + 1))
done

#find if user does not exist
if [[ -z $USER_ID ]]
then
  #does not
  INSERT_RESULT=$($PSQL "INSERT INTO users (user_name) VALUES ('$USERNAME')")
  USER_ID=$($PSQL "SELECT user_id FROM users WHERE user_name='$USERNAME'")
fi
#insert data
INSERT_RESULT=$($PSQL "INSERT INTO games (secret_number,tries,user_id) VALUES ($SECRET_NUMBER,$TRIES,$USER_ID)")
#secret number guessed output
echo "You guessed it in $TRIES tries. The secret number was $SECRET_NUMBER. Nice job!"


