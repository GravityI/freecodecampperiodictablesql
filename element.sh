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
        echo "The element's atomic number is $1"
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
          echo "The element's symbol is $1"
        fi
      else
        echo "The element's name is $1"
      fi
    fi
  else
    echo 'Please provide an element as an argument.'
  fi
}

GET_ELEMENT ()
{
  #boilerplate for correct output
  echo "$1"
}

IDENTIFY_ELEMENT $1