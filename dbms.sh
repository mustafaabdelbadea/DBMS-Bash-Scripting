#!/bin/bash
RED='\033[0;31m'
GREEN='\033[0;32m'
Color_Off='\033[0m'
Blue='\033[0;34m' 
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
	1) createDatabase ;;
	2) listDatabases ;;
	3) connectDatabase ;;
	4) dropDatabase ;;
	5) exit ;;
	*) mainMenu ;;
	esac
}

function createDatabase {
	echo "Enter Your database name to create"
	read databaseName
	if [[ $databaseName =~ ^[a-zA-Z]+$ ]]; then
		mkdir ./DBMS/$databaseName 2>>./.error.log
		if [[ $? == 0 ]]; then
			echo -e "${GREEN} $databaseName  has been created successfully ${Color_Off}"
			pwd
		else
			echo -e "${RED}Error creating database ${Color_Off}"
			echo -e "${RED}Database already exists ${Color_Off}"
		fi
	else
		echo invalid database name
	fi
	mainMenu
}

function listDatabases {

	databaseCount=$(ls ./DBMS | wc -l)
	if [[ $databaseCount -eq 0 ]]; then
		echo -e "${RED} No databases yet ${Color_Off}"
	else
		echo -e "${Blue} --------Databases---------- ${Color_Off}"
		ls ./DBMS
	fi

	mainMenu

}

function dropDatabase {
	echo "Enter database name to drop"
	read databaseName

	rm -r ./DBMS/$databaseName 2>>./.error.log
	if [[ $? == 0 ]]; then
		echo -e "{GREEN} $databaseName Dropped Successfully {Color_Off}"
	else
		echo -e "${RED} Error while dropping database {Color_Off}"
		echo "${RED} Wrong name or database doesn't exist {Color_Off}"
	fi
	mainMenu
}

function connectDatabase {
	echo "Enter database name to connect"
	read databaseName
	pwd
	cd DBMS/$databaseName 2>>./.error.log

	if [[ $? == 0 ]]; then
		echo -e "${GREEN} Connected to $databaseName Successfully ${Color_Off}"
	else
		echo -e "${RED} Error Connecting database, DB doesn't exist ${Color_Off}"
		createDatabase
	fi

	#-z option check for length of string = zero
	# if [[ -z $databaseName ]]
	# 	then
	# 	echo "Enter Name"
	# 	connectDatabase
	# 	elif [[ $databaseName =~ ^[a-zA-Z]+$ ]]
	# 	then
	# 		pwd
	# 		#check if there is a directory -d
	# 		if [[ -d DBMS/$databaseName ]]
	# 		then
	# 			echo "Connected"
	# 			cd DBMS/$databaseName
	# 		else
	# 			echo "Database doesn't exists, Please Create DB first"
	# 			createDatabase
	# 		fi
	# fi

	mainMenu
}

mainMenu
