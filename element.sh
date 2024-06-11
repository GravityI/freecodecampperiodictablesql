#! /bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

IDENTIFY_ELEMENT ()
{
  if [[ $1 ]]
  then
    #check if input is a number
    NUMBER_PATTERN='^[0-9]+$'
    if [[ $1 =~ $NUMBER_PATTERN ]]
    then
      #check if input is a valid atomic number
      ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number = $1")
      if [[ -z $ATOMIC_NUMBER ]]
      then
        echo "I could not find that element in the database."
      else
        GET_ELEMENT 'NUMBER' $1
      fi
    else
      #check if input is a valid name
      NAME=$($PSQL "SELECT name FROM elements WHERE name = '$1'")
      if [[ -z $NAME ]]
      then
        #check if input is a valid symbol
        SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE symbol = '$1'")
        if [[ -z $SYMBOL ]]
        then
          echo "I could not find that element in the database."
        else
          GET_ELEMENT 'SYMBOL' $1
        fi
      else
        GET_ELEMENT 'NAME' $1
      fi
    fi
  else
    echo 'Please provide an element as an argument.'
  fi
}

GET_ELEMENT ()
{
  #boilerplate for correct output
  case $1 in
  'NUMBER')
    NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number = $2")
    SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number = $2")
  ;;
  'NAME')
    ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE name = '$2'")
    SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE name = '$2'")
  ;;
  'SYMBOL')
    ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE symbol = '$2'")
    NAME=$($PSQL "SELECT name FROM elements WHERE symbol = '$2'")
  ;;
  esac
  TYPE_ID=$($PSQL "SELECT type_id FROM properties WHERE atomic_number = $ATOMIC_NUMBER")
  TYPE=$($PSQL "SELECT type FROM types WHERE type_id = $TYPE_ID")
  ATOMIC_MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number = $ATOMIC_NUMBER")
  MELTING_POINT=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number = $ATOMIC_NUMBER")
  BOILING_POINT=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number = $ATOMIC_NUMBER")
  echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
}

IDENTIFY_ELEMENT $1