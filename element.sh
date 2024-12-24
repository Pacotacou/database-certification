#!/bin/bash
#sql variable
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"
#if no argument
if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
#if argument
else
  #if the argument is an Integer
  if [[ "$1" =~ ^-?[0-9]+$ ]]
  then
    ATOMIC_NUMBER=$1
  #if its an upper case letter
  else
    ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE symbol='$1' OR name='$1'")
  fi
  #get symbol and name
  SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number=$ATOMIC_NUMBER")
  NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number=$ATOMIC_NUMBER")

  #if no result
  if [[ -z $NAME ]] 
  then
    echo "I could not find that element in the database."
  #if result
  else
    TYPE=$($PSQL "SELECT types.type FROM types INNER JOIN properties USING(type_id) INNER JOIN elements USING(atomic_number) WHERE elements.atomic_number=$ATOMIC_NUMBER")
    ATOMIC_MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
    MELTING_POINT_CELSIUS=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
    BOILING_POINT_CELSIUS=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
    echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT_CELSIUS celsius and a boiling point of $BOILING_POINT_CELSIUS celsius."
  fi
fi