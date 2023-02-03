
#!/bin/bash

mkdir -p ./DBMS
echo "Weclome to our DBMS"
echo "Made by Mustafa and Adham"
echo "Under the supervision of DR.Sherine <3"

function mainMenu {
echo "Enter Your choice : "
echo "1. Create Database : "
echo "2. List Databases : "
echo "3. Connect to  Database : "
echo "4. Drop Database : "
echo "5. Exit "
read choice
case $choice in
1) createDatabase;;
2) listDatabases;;
3) connectDatabase;;
4) dropDatabase;;
5) exit;;
*) mainMenu;;
esac
}

function createDatabase {
echo "Enter Your database name"
read databaseName
if [[ $databaseName =~ ^[a-zA-Z]+$ ]]  
then
	mkdir ./DBMS/$databaseName 2>> ./.error.log
	if [[ $? == 0 ]]
	then
		echo " $databaseName created " 
		
	else
		echo error creating database
		echo database exist
	fi
else
	echo invalid database name
fi
mainMenu
}

function listDatabases {

databaseCount=$(ls ./DBMS | wc -l)
	if [[ $databaseCount -eq 0 ]]
	then
		echo "No databases yet"
	else
		echo "--------Databases----------"
		ls ./DBMS
	fi

mainMenu

}

function dropDatabase {
echo enter database name  to drop
read databaseName

rm -r ./DBMS/$databaseName 2>> ./.error.log
if [[ $? == 0 ]]
        then
            	echo " $databaseName Dropped "
        else
            	echo "error dropping database"
                echo "wrong name or database doesn't exist"
        fi
mainMenu
}

function connectDatabase {
	echo hi

mainMenu
}


mainMenu
