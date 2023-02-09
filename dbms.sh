#!/bin/bash

source ./utils/colors.sh 2>>.error.log
source ./utils/util.sh 2>>.error.log
cat hello.txt 2>>.error.log

mkdir -p ./DBMS
echo -e "Made by ${Blue} \e]8;;${AUTHOR_ONE_LINKEDIN}\a${AUTHOR_ONE} \e]8;;\a ${Color_Off} and ${Blue}\e]8;;${AUTHOR_TWO_LINKEDIN}\a${AUTHOR_TWO}\e]8;;\a${Color_Off}"
echo -e "* Contact Us${Blue} \e]8;;${AUTHOR_ONE_LINKEDIN}\a${AUTHOR_ONE}\e]8;;\a ${Color_Off}, ${Blue} \e]8;;${AUTHOR_TWO_LINKEDIN}\a${AUTHOR_TWO}\e]8;;\a ${Color_Off}"

# echo -e "Under the supervision of ${SUPERVISOR} ${RED}<3${Color_Off}"

function exitProgram {
	cat exit.txt 2>>.error.log
	echo -e "\n"
	echo -e "* Contact Us${Blue} \e]8;;${AUTHOR_ONE_LINKEDIN}\a${AUTHOR_ONE}\e]8;;\a ${Color_Off}, ${Blue} \e]8;;${AUTHOR_TWO_LINKEDIN}\a${AUTHOR_TWO}\e]8;;\a ${Color_Off}"
}

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
	5) exitProgram; exit ;;
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
		rm ./.$choice 2>>../../.error.log
		rm $choice 2>>../../.error.log
		if [[ $? == 0 ]]; then
			echo -e "${GREEN}DB $choice Deleted Successfully${Color_Off}"
		else
			echo -e "${RED}Error while deleting table, Invalid DB name${Color_Off}"
		fi
	fi
	tableMenu
}

function createTable {
	tableName=""

	while [[ -z $tableName ]]; do
		echo "Enter table name"
		read tableName
	done

	if [[ -f $tableName ]]; then
		echo -e "${RED}Table already exists${Color_Off}"
		tableMenu
	fi

	colNumber=0

	while [[ colNumber -lt 1 ]]; do
		echo "Enter number of columns"
		read colNumber
	done

	counter=1
	primaryKey=""

	metaData="field"$separator"type"$separator"pKey"
	while [ $counter -le $colNumber ]; do
		echo "Enter name of column no. $counter"
		read columnName
		echo "Enter type of column $columnName  (str/int)"
		select type in "str" "int"; do
			case $type in
			str)
				columnType="str"
				break
				;;
			int)
				columnType="int"
				break
				;;
			*)
				echo "wrong choice"
				;;
			esac
		done

		if [[ $primaryKey == "" ]]; then
			echo "Would you like this column to be the primary key ?(yes/no)"
			select ans in "yes" "no"; do
				case $ans in
				yes)
					primaryKey="PK"
					metaData+=$"\n"$columnName$separator$columnType$separator$primaryKey
					break
					;;
				no)
					metaData+=$"\n"$columnName$separator$columnType$separator$primaryKey
					break
					;;
				*) echo "wrong choice" ;;
				esac
			done
		else
			metaData+=$"\n"$columnName$separator$columnType$separator
		fi

		if [[ $counter == $colNumber ]]; then
			if [[ -z $primaryKey ]]; then
				echo -e "${ORANGE}You didn't choose primary key by default last row will be the primary key${Color_Off}"
				primaryKey="PK"
				metaData+=$primaryKey
			fi

			temp=$temp$columnName
		else
			temp=$temp$columnName$separator
		fi

		((counter++))
	done
	touch .$tableName
	echo -e $metaData >>.$tableName
	touch $tableName
	echo -e $temp >>$tableName
	if [[ $? == 0 ]]; then
		echo -e "${GREEN}Table Created${Color_Off}"
		tableMenu
	else
		echo -e "${RED}Error while creating table $tableName${Color_Off}"
		tableMenu
	fi
}

function insert {
	echo -e "${Blue}---------------- Insert -------------------${Color_Off}"
	echo "Enter table name to insert"
	read tableName

	if [[ ! -f $tableName ]]; then
		echo -e "${RED}Table doesn't exist${Color_Off}"
		tableMenu
	else
		typeset -i colCount=2
		typeset -i colsNumber=$(awk 'END{print NR}' .$tableName)

		while [ $colCount -le $colsNumber ]; do
			currentCol=$(awk -F# '{if(NR == '$colCount') print $1}' .$tableName)
			currentType=$(awk -F# '{if(NR == '$colCount') print $2}' .$tableName)
			isPrimary=$(awk -F# '{if(NR == '$colCount') print $3}' .$tableName)

			echo "Enter value of $currentCol column"
			read currentValue

			if [[ $currentType == "str" ]]; then
				while [[ ! $currentValue =~ ^[a-zA-Z]*$ ]]; do
					echo "Enter value of $currentCol column"
					read currentValue
				done
			elif [[ $currentType == "int" ]]; then
				while [[ ! $currentValue =~ ^[0-9]*$ ]]; do
					echo "Enter value of $currentCol column"
					read currentValue
				done
			fi

			if [[ $isPrimary == "PK" ]]; then
				#-z check if value is empty
				if [[ -z $currentValue ]]; then
					echo -e "${RED}Primary key can not be empty!${Color_Off}"
					continue
				fi

				primaryKey=$(cut -d# -f$(($colCount - 1)) $tableName | grep "^$currentValue")

				if [[ $primaryKey == $currentValue ]]; then
					echo -e "${RED}Primary key found!${Color_Off}"
					continue
				fi
			fi

			if [[ $colCount == $colsNumber ]]; then
				row=$row$currentValue
			else
				row=$row$currentValue$separator
			fi
			colCount=$colCount+1

		done

		echo $row >>$tableName 2>>../../.error.log

		if [[ $? == 0 ]]; then
			echo -e "${GREEN}Row has been Inserted Successfully${Color_Off}"
		else
			echo -e "${RED}Error while Inserting Data into Table $tableName${Color_Off}"
		fi
		row=""
		tableMenu
	fi

}

function selectTable {

	echo -e "${Blue}-------------- Select ------------------${Color_Off}"
	tableName=""

	while [[ ! -f $tableName ]]; do
		echo "Enter table name"
		read tableName
	done

	echo "Enter your selection choice"
	select choice in "Select All" "Select Column" "Select Row" "Table Menu" "Exit"; do
		case $choice in
		"Select All")
			#column -t --> format table with delimiter whitespace, -s --> to specify delimiter
			#awk -v define variable
			column -t -s "$separator" $tableName | awk -v counter=0 -v C0=$Color_Off -v H=$HEAD_BLUE -v C1=$CELL_GREY -v C2=$CELL_BLUE -v C3=$Cyan '{ if (NR == 1) print H $0 C0; else if(NR%2 == 0) print C1 $0 C0; else print C2 $0 C0;} END{print C3 "Total number of rows = "((NR-1)) C0}'
			tableMenu
			;;

		"Select Column")
			colNumber=0
			counter=0

			#To retrive columns names
			data=$(awk -F# '{ for(i = 1 ; i <= NF; i++) {if (NR==1) { print $i } } }' $tableName)

			echo "Enter column name"

			for column in $data; do
				((counter++))
				echo "$counter. To select $column"
			done

			read colNumber

			while [[ ! $colNumber =~ ^[1-$counter]$ ]]; do
				echo -e "${RED}Enter valid choice${Color_Off}"
				read colNumber
			done

			# while [[ ! $colNumber =~ ^[1-9]+$ ]]; do
			# 	echo "Enter Column Number"
			# 	read colNumber
			# done

			awk -v C0=$Color_Off -v H=$HEAD_BLUE -v C1=$CELL_GREY -v C2=$CELL_BLUE -v C3=$Cyan 'BEGIN{FS="'$separator'"}{if(NR==1) print H $'$colNumber' C0; else if(NR%2 == 0) print C1 $'$colNumber' C0; else print C2 $'$colNumber' C0} END{print C3 "Total number of rows = "((NR-1)) C0}' $tableName
			tableMenu
			;;

		"Select Row")
			counter=0
			choice=0

			#To retrive row names
			data=$(awk -F# '{ for(i = 1 ; i <= NF; i++) {if (NR==1) { print $i } } }' $tableName)

			echo "Enter row name"

			for row in $data; do
				((counter++))
				echo "$counter. To select $row"
			done

			read choice

			while [[ ! $choice =~ ^[1-$counter]$ ]]; do
				echo -e "${RED}Enter valid choice${Color_Off}"
				read choice
			done

			echo "Enter value to search"
			read searchVal
			awk -v C0=$Color_Off -v H=$HEAD_BLUE -v C1=$CELL_GREY -v C2=$CELL_BLUE -v rowsCount=0 -v C3=$Cyan 'BEGIN{FS="#"}{if ( NR == 1 ) print H $0 C0; if ( $'$choice' == "'$searchVal'" ) {  ((rowsCount++)); if(NR%2 == 0) print C1 $0 C0; else print C2 $0 C0}} END{print C3 "Total number of rows = "rowsCount C0}' $tableName | column -t -s "#"

			# totalRows=""
			# for row in $data; do
			# 	totalRows+=$row","
			# done 

			# echo $totalRows

			#  awk  'BEGIN{FS="#"}{if ( $'$choice' == "'$searchVal'" ) print $0 }' $tableName | column -t -J  -s "#" -J --table-columns $totalRows > $tableName.json

			tableMenu
			;;

		
			"Table Menu") tableMenu ;;
		"Exit") exitProgram; exit ;;
		*)
			echo -e "${RED}Invalid choice${Color_Off}"
			selectTable
			;;
		esac
	done

}

function deleteFromTable {
	echo "delete"
}

function updateTable {
	echo "update"
}

function tableMenu {
	echo -e "${Blue}---------- Table Menu -----------${Color_Off}"
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
	1) createTable ;;
	2) listTables ;;
	3) dropTable ;;
	4) insert ;;
	5) selectTable ;;
	6) deleteFromTable ;;
	7) updateTable ;;
	8) backToMain ;;
	9) exitProgram; exit ;;
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
		else
			echo -e "${RED}Error creating database ${Color_Off}"
			echo -e "${RED}Database already exists ${Color_Off}"
		fi
	else
		echo -e "${RED}Invalid database name${Color_Off}"
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
		echo -e "${GREEN}$databaseName Dropped Successfully ${Color_Off}"
	else
		echo -e "${RED}Error while dropping database ${Color_Off}"
		echo -e "${RED}Wrong name or database doesn't exist ${Color_Off}"
	fi
	mainMenu
}

function connectDatabase {
	databaseName=""

	while [[ -z $databaseName ]]; do
		echo "Enter database name to connect"
		read databaseName
	done

	cd DBMS/$databaseName 2>>./.error.log

	if [[ $? == 0 ]]; then
		echo -e "${GREEN}Connected to $databaseName Successfully ${Color_Off}"
		tableMenu
	else
		echo -e "${RED}Error Connecting database, DB doesn't exist ${Color_Off}"
		mainMenu
	fi
}

mainMenu
