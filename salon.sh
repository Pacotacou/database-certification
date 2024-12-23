#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=salon -t -c "

APPOINTMENT_MENU(){
  #get phone number
  echo -e "\nWhat's your phone number?"
  read CUSTOMER_PHONE
  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")
  #if not found
  if [[ -z $CUSTOMER_NAME ]]
  then
    #ask customer name
    echo -e "I don't have a record for that phone number, what's your name?"
    read CUSTOMER_NAME
    #insert new customer with name and phone
    CUSTOMER_INSERT_RESULT=$($PSQL "INSERT INTO customers (name,phone) VALUES ('$CUSTOMER_NAME','$CUSTOMER_PHONE')")
  fi
  #get customer id
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
  #ask for appointment time
  echo -e "What time would you like your $SERVICE_NAME, $CUSTOMER_NAME?"
  read SERVICE_TIME
  #insert appointment
  APPOINTMENT_INSERT_RESULT=$($PSQL "INSERT INTO appointments (service_id,customer_id,time) VALUES ($SERVICE_ID_SELECTED,$CUSTOMER_ID,'$SERVICE_TIME')")
  echo -e "\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
}

MAIN_MENU(){

  #display parameter message
  if [[ ! -z $1 ]]
  then
    echo -e "\n$1"
  fi
  #get services
  SERVICES=$($PSQL "SELECT service_id, name FROM services")
  #display services
  echo "$SERVICES" | while read SERVICE_ID BAR SERVICE_NAME
  do
    echo "$SERVICE_ID) $SERVICE_NAME"
  done
  #get selected id
  read SERVICE_ID_SELECTED
  SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED") 
  #if  found
  if [[ $SERVICE_NAME ]]
  then
    APPOINTMENT_MENU 
  else
    MAIN_MENU "I could not find that service. What would you like today?"
  fi
}

echo -e "\n~~~~~ MY SALON ~~~~~"
MAIN_MENU "Welcome to My Salon, how can I help you?"
