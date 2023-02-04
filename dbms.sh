#!/bin/bash
source ./colors.sh
mkdir -p ./DBMS
echo "Weclome to our DBMS"
echo "Made by Mustafa and Adham"
echo -e "Under the supervision of DR.Sherine ${RED}<3${Color_Off}"

function mainMenu {
	echo "Enter Your choice"
	echo "1. Create Database"
	echo "2. List Databases"
	echo "3. Connect to  Database"
	echo "4. Drop Database"
	echo "5. Exit"
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

function backToMain {
	cd ../.. 2>>../../.error.log
	if [[ $? == 0 ]]; then
		clear
		echo -e "${Yellow}Disconnected !${Color_Off}"
		mainMenu
	else
		echo -e "${RED}Error while Disconnecting !${Color_Off} "
	fi
}

function listTables {
	# -1 option used to display file per line | wc check for lines
	if [[ $(ls -1 | wc -l) -eq 0 ]]; then
		echo -e "${RED}DB is Empty no Tables Found${Color_Off}"
	else
		clear
		echo -e "${Blue}--------- Tables ----------"
		ls -1 2>>../../.error.log
		echo -e "----------------------------------------------------------${Color_Off}"
	fi

	tableMenu
}

function dropTable {
	clear
	echo "Enter name of table or 0 to back to tables menu"
	read choice
	if [[ $choice == 0 ]]; then
		echo "Back"
		tableMenu
	else
		rm $choice 2>>../../.error.log
		if [[ $? == 0 ]]; then
			echo -e "${GREEN}DB $choice Deleted Successfully${Color_Off}"
		else
			echo -e "${RED}Error while deleting table, Invalid DB name${Color_Off}"
		fi
	fi
	tableMenu
}

function tableMenu {
	echo "---------- Table Menu -----------"
	echo "1. Create Table"
	echo "2. List Tables"
	echo "3. Drop Table"
	echo "4. Insert into Table"
	echo "5. Select from Table"
	echo "6. Delete from Table"
	echo "7. Update Table"
	echo "8. Back to main menu"
	echo "9. Exit"

	read choice

	case $choice in
	1) echo "create table" ;;
	2) listTables ;;
	3) dropTable ;;
	4) echo "Insert into table" ;;
	5) echo "select table" ;;
	6) echo "delete" ;;
	7) echo "Update Table" ;;
	8) backToMain ;;
	9) exit ;;
	*)
		echo -e "${RED}Invalid choice${Color_Off}"
		tableMenu
		;;
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
	clear
	databaseCount=$(ls ./DBMS | wc -l)
	if [[ $databaseCount -eq 0 ]]; then
		echo -e "${RED} No databases yet ${Color_Off}"
	else
		echo -e "${Blue}--------Databases----------"
		ls -1 ./DBMS
		echo -e "${Color_Off}"
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
		tableMenu
	else
		echo -e "${RED} Error Connecting database, DB doesn't exist ${Color_Off}"
		mainMenu
	fi
}

mainMenu
