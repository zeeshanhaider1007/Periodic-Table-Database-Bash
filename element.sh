## periodic_table script

PRINT_FUNC(){
  echo "The element with atomic number $1 is $2 ($3). It's a $4, with a mass of $5 amu. $2 has a melting point of $6 celsius and a boiling point of $7 celsius."
}
PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

if [[ $1 ]]
then
## if argument is entered the process input
if [[ ${1} =~ ^[0-9]+$ ]]
then
check_element=$($PSQL "select atomic_number, symbol, name from elements where atomic_number = ${1} limit 1")
else
# check symbol present
check_element=$($PSQL "select atomic_number, symbol, name from elements where symbol = '$1' limit 1")
fi
# check atomic number or symbol present
if [[ -z $check_element ]]
then
# search in element names
check_element=$($PSQL "select atomic_number, symbol, name from elements where name = '$1' limit 1")
fi

if [[ -z $check_element ]]
then
echo "I could not find that element in the database."
else
## read element data into separate variables
read ATOMIC_NUMBER BAR SYMBOL BAR NAME <<< "${check_element}"
# fetch properties data from data base
fetch_properties=$($PSQL "select type_id, atomic_mass, melting_point_celsius, boiling_point_celsius from properties where atomic_number = $ATOMIC_NUMBER limit 1")
# read properties into separate variables
read TYPE_ID BAR ATOMIC_MASS BAR MELTING BAR BOILING <<< "${fetch_properties}"
#fetch and read type from types table
fetch_type=$($PSQL "select type from types where type_id = $TYPE_ID")
read TYPE <<< "${fetch_type}"
PRINT_FUNC $ATOMIC_NUMBER $NAME $SYMBOL $TYPE $ATOMIC_MASS $MELTING $BOILING
fi

else
echo "Please provide an element as an argument."
fi