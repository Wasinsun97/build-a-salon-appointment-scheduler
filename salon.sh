#! /bin/bash
PSQL="psql --username=freecodecamp --dbname=salon -t --no-align -c"


MAIN_MENU() {
  if [[ $1 ]]
  then
    echo -e "\n$1\n"
  fi

  echo "Please select the service:"
  # get all services
  ALL_SERVICES=$($PSQL "SELECT * FROM services")
  # display all services
  # FORMATED_ALL_SERVICES=$(echo "$ALL_SERVICES" | sed 's/|/)/')
  echo "$ALL_SERVICES" | while read SERVICE
  do
    echo "$SERVICE" | sed 's/|/) /'
  done
  # select service
  read SERVICE_ID_SELECTED
  case $SERVICE_ID_SELECTED in
    1) APPOINTMENT 'service_1' ;;
    2) APPOINTMENT 'service_2' ;;
    3) APPOINTMENT 'service_3' ;;
    *) MAIN_MENU "Please enter valid option."
  esac
}

APPOINTMENT() {
  SERVICE_NAME=$1
  echo -e "\n~~~Making an apoinment for $SERVICE_NAME~~~\n"
  echo -e "\nWhat's you phone number?:"
  read CUSTOMER_PHONE
  # get customer_id
  CUSTOMER_ID=$($PSQL "SELECT customer_id from customers WHERE phone = '$CUSTOMER_PHONE'")
  # if not found
  if [[ -z $CUSTOMER_ID ]]
  then
    # insert new customer
    echo -e "\nWhat's your name?:"
    read CUSTOMER_NAME
    INSERT_NEW_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")
    CUSTOMER_ID=$($PSQL "SELECT customer_id from customers WHERE phone = '$CUSTOMER_PHONE'")
  else
    CUSTOMER_NAME=$($PSQL "SELECT name from customers WHERE phone = '$CUSTOMER_PHONE'")
  fi
  # insert new appointment
  echo -e "\nWhat time would you like to be here?:"
  read SERVICE_TIME
  INSERT_NEW_APPOINTMENT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")
  # making appointment done
  echo -e "\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
}

MAIN_MENU