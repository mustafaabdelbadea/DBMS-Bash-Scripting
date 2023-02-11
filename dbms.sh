#!/bin/bash

source ./utils/colors.sh 2>>.error.log
source ./utils/util.sh 2>>.error.log
source ./utils/env.sh 2>>.error.log

clear

cat hello.txt 2>>.error.log

mkdir -p ./DBMS
mkdir -p ./Exported
echo -e "Made by ${Blue} \e]8;;${AUTHOR_ONE_LINKEDIN}\a${AUTHOR_ONE} \e]8;;\a ${Color_Off} and ${Blue}\e]8;;${AUTHOR_TWO_LINKEDIN}\a${AUTHOR_TWO}\e]8;;\a${Color_Off}"
echo -e "* Contact Us${Blue} \e]8;;${AUTHOR_ONE_LINKEDIN}\a${AUTHOR_ONE}\e]8;;\a ${Color_Off}, ${Blue} \e]8;;${AUTHOR_TWO_LINKEDIN}\a${AUTHOR_TWO}\e]8;;\a ${Color_Off}"

# echo -e "Under the supervision of ${SUPERVISOR} ${RED}<3${Color_Off}"

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
	5)
		exitProgram
		exit
		;;
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
		pwd
		rm .$choice 2>>../../.error.log
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

	echo "Enter table name"
	read tableName

	while [[ ! $tableName =~ ^[a-zA-Z]+$ ]]; do
		echo -e "${RED}Enter a Vaild Name${Color_Off}"
		read tableName
	done

	if [[ -f $tableName ]]; then
		echo -e "${RED}Table already exists${Color_Off}"
		tableMenu
	fi

	colNumber=0

	echo "Enter number of columns"
	read colNumber

	while [[ ! $colNumber =~ ^[1-9]+$ ]]; do
		echo -e "${RED}Enter a Valid number of columns${Color_Off}"
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
			currentCol=$(awk -F$separator '{if(NR == '$colCount') print $1}' .$tableName)
			currentType=$(awk -F$separator '{if(NR == '$colCount') print $2}' .$tableName)
			isPrimary=$(awk -F$separator '{if(NR == '$colCount') print $3}' .$tableName)
			echo $isPrimary
			echo "Enter value of $currentCol column"
			read currentValue

			if [[ $currentType == "str" ]]; then
				while [[ ! $currentValue =~ ^[a-zA-Z]*$ ]]; do
					echo -e "${RED}Enter value of $currentCol column${Color_Off}"
					read currentValue
				done
			elif [[ $currentType == "int" ]]; then
				while [[ ! $currentValue =~ ^[0-9]*$ ]]; do
					echo -e "${RED}Enter value of $currentCol column${Color_Off}"
					read currentValue
				done
			fi

			if [[ $isPrimary == "PK" ]]; then
				#-z check if value is empty
				if [[ -z $currentValue ]]; then
					echo -e "${RED}Primary key can not be empty!${Color_Off}"
					continue
				fi

				primaryKey=$(cut -d$separator -f$(($colCount - 1)) $tableName | grep "^$currentValue")

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

	echo "Enter table name"
	read tableName

	while [[ ! -f $tableName ]]; do
		echo -e "${RED}Enter valid table name${Color_Off}"
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
			data=$(awk -F$separator '{ for(i = 1 ; i <= NF; i++) {if (NR==1) { print $i } } }' $tableName)

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

			#To retrive columns names
			data=$(awk -F$separator '{ for(i = 1 ; i <= NF; i++) {if (NR==1) { print $i } } }' $tableName)

			echo "Enter column name"

			for column in $data; do
				((counter++))
				echo "$counter. To select $column"
			done

			read choice

			while [[ ! $choice =~ ^[1-$counter]$ ]]; do
				echo -e "${RED}Enter valid choice${Color_Off}"
				read choice
			done

			echo "Enter value to search"
			read searchVal
			awk -v C0=$Color_Off -v H=$HEAD_BLUE -v C1=$CELL_GREY -v C2=$CELL_BLUE -v rowsCount=0 -v C3=$Cyan 'BEGIN{FS="'$separator'"}{if ( NR == 1 ) print H $0 C0; if ( $'$choice' == "'$searchVal'" ) {  ((rowsCount++)); if(NR%2 == 0) print C1 $0 C0; else print C2 $0 C0}} END{print C3 "Total number of rows = "rowsCount C0}' $tableName | column -t -s "$separator"

			tableMenu
			;;

		
			"Table Menu") tableMenu ;;
		"Exit")
			exitFromSubTable
			exit
			;;
		*)
			echo -e "${RED}Invalid choice${Color_Off}"
			;;
		esac
	done

}

function deleteRows {
	echo helllo
}

function deleteColumn {
	colNumberDelete=0
	counter=0

	#To retrive columns names
	data=$(cat .$tableName | wc -l)
	data=$((data-1))
	echo $data
	echo "Enter column you want to delete in"
	read colNumberDelete

	while [[ ! $colNumberDelete =~ ^[1-$data]$ ]]; do
		echo -e "${RED}Enter valid choice${Color_Off}"
		read colNumberDelete
	done

	isPrimary=$(awk -F$separator '{if(NR == '$colNumberDelete+1') print $3}' .$tableName)

	if [[ $isPrimary == "PK" ]]; then
		echo -e "${RED}Can't delete the Primary key column${Color_Off}"
		echo -e "${RED}Choose the right table name or column${Color_Off}"

		deleteColumn
	else

		getCol=$colNumberDelete+1

		awk -v C0=$Color_Off -v C3=$Cyan  -v colNumberUpdate=$colNumberUpdate 'BEGIN {FS = OFS="'$separator'"} {sub($colNumberUpdate,"",$colNumberUpdate);print $0 >"'$tableName'"} END{print C3 "Total number of rows = "((NR-1)) C0}' $tableName

		if [[ $? == 0 ]]; then
			sed $getCol'd' .$tableName > .$tableName
			if [[ $? == 0 ]]; then
				echo -e "${GREEN}Updated Successfully${Color_Off}"
			else
				echo -e "${RED}Error while Updating Table $tableName${Color_Off}"
			fi
		else
			echo -e "${RED}Error while Updating Table $tableName${Color_Off}"
		fi

		tableMenu
	fi
}

function deleteFromTable {
	tableName=""

	echo "Enter table name"
	read tableName

	while [[ ! -f $tableName ]]; do
		echo -e "${RED}Enter valid table name${Color_Off}"
		read tableName
	done

	echo "Enter your delete choice"

	select choice in "Delete a column" "Dalete Rows" "Exit"; do
		case $choice in
		"Delete a column")
			deleteColumn
			;;
		"Delete Rows")
			deleteRows
			;;
		"Exit")
			exitFromSubTable
			exit
			;;
		*)
			echo -e "${RED}Invalid Choice${Color_Off}"
			;;
		esac
	done
}

function updateColumns {
	colNumberUpdate=0
	counter=0

	#To retrive columns names
	data=$(awk -F$separator '{ for(i = 1 ; i <= NF; i++) {if (NR==1) { print $i } } }' $tableName)

	echo "Choose column you want to update in"
	for column in $data; do
		((counter++))
		echo "$counter. To select $column"
	done

	read colNumberUpdate

	while [[ ! $colNumberUpdate =~ ^[1-$counter]$ ]]; do
		echo -e "${RED}Enter valid choice${Color_Off}"
		read colNumberUpdate
	done

	isPrimary=$(awk -F$separator '{if(NR == '$colNumberUpdate+1') print $3}' .$tableName)

	if [[ $isPrimary == "PK" ]]; then
		echo -e "${RED}Can't update the Primary key column${Color_Off}"
		echo -e "${RED}Choose the right table name or column${Color_Off}"

		updateTable
	else

		validationCol=$colNumberUpdate+1

		currentCol=$(awk -F$separator '{if(NR == '$validationCol') print $1}' .$tableName)
		currentType=$(awk -F$separator '{if(NR == '$validationCol') print $2}' .$tableName)

		echo "Enter the new value of $currentCol column"
		read newValue

		if [[ $currentType == "str" ]]; then
			while [[ ! $newValue =~ ^[a-zA-Z]*$ ]]; do
				echo -e "${RED}Enter valid value of $currentCol column${Color_Off}"
				read newValue
			done
		elif [[ $currentType == "int" ]]; then
			while [[ ! $newValue =~ ^[0-9]*$ ]]; do
				echo -e "${RED}Enter valid value of $currentCol column${Color_Off}" 
				read newValue
			done
		fi

		# while [[ $rowCount -le $numOfRows ]]; do
		# 	#numOfRows=$(awk -F '#' '{if (NR>1) {print NR} }' $tableName)
		# 	#oldValue=$(awk -F '#' '{if (NR=='$rowCount') {print $'$colNumberUpdate'} }' $tableName)
		# 	#oldValue=$(awk -F '#' '{ if (NR>1) {print $'$colNumberUpdate'} }' $tableName)
		# 	#echo $oldValue
		# 	#sed -i ''$rowCount's/'$oldValue'/'$newValue'/g' $tableName #2>> ./.error.log
		# 	#echo $colNumberUpdate
		# 	pwd
		# 	((rowCount++))
		# done

		echo $newValue
		echo $colNumberUpdate

		awk -v C0=$Color_Off -v C3=$Cyan  -v colNumberUpdate=$colNumberUpdate -v newValue=$newValue 'BEGIN {FS = OFS="'$separator'"} {if(NR > 1) {sub($colNumberUpdate,newValue,$colNumberUpdate)} print $0 >"'$tableName'"} END{print C3 "Total number of rows = "((NR-1)) C0}' $tableName

		if [[ $? == 0 ]]; then
			echo -e "${GREEN}Updated Successfully${Color_Off}"
		else
			echo -e "${RED}Error while Updating Table $tableName${Color_Off}"
		fi

		tableMenu
	fi
}

function updateRows {
	colNumberUpdate=0
	counter=0
	updateBy=0
	oldValue=""
	newValue=""

	#To retrive columns names
	data=$(awk -F$separator '{ for(i = 1 ; i <= NF; i++) {if (NR==1) { print $i } } }' $tableName)

	echo "Update which column "
	for column in $data; do
		((counter++))
		echo "$counter $column"
	done
	read colNumberUpdate

	while [[ ! $colNumberUpdate =~ ^[1-$counter]$ ]]; do
		echo -e "${RED}Enter valid choice${Color_Off}"
		read colNumberUpdate
	done

	isPrimary=$(awk -F$separator '{if(NR == '$colNumberUpdate+1') print $3}' .$tableName)
	counter=0
	echo "Update row where "
	for column in $data; do
		((counter++))
		echo "$counter $column"
	done
	echo "equals ?"
	read updateBy

	while [[ ! $updateBy =~ ^[1-$counter]$ ]]; do
		echo -e "${RED}Enter valid choice${Color_Off}"
		read updateBy
	done

	echo "enter the condition value "
	read oldValue
	echo "enter the new value of the field"
	read newValue

	#if [[ $isPrimary == "PK"]]
	echo start awk
	#awk -v ov=$oldValue -v nv=$newValue -v field=$updateBy -v update=$colNumberUpdate 'BEGIN {FS = OFS="'$separator'"}{if($field==ov){sub($update,nv,$update)}print $0 > "'$tableName'"} END{print C3 "Total number of rows = "((NR-1)) C0}' $tableName
	#awk -v ov=$oldValue -v nv=$newValue -v conditionField=$updateBy -v updateField=$colNumberUpdate 'BEGIN{FS = OFS="'$separator'"}{if($conditionField==ov){$updateField=nv; print $updateField}}' $tableName
	if [[ $? == 0 ]]
	then
		echo "Updated"
	fi
	tableMenu
}

function updateTable {
	tableName=""

	echo "Enter table name"
	read tableName

	while [[ ! -f $tableName ]]; do
		echo -e "${RED}Enter valid table name${Color_Off}"
		read tableName
	done

	echo "Enter your update choice"

	select choice in "Update a whole column" "Update Rows" "Exit"; do
		case $choice in
		"Update a whole column")
			updateColumns
			;;
		"Update Rows")
			updateRows
			;;
		"Exit")
			exitFromSubTable
			exit
			;;
		*)
			echo -e "${RED}Invalid Choice${Color_Off}"
			;;
		esac
	done
}

function exportTable {

	echo -e "${Blue}-------------- Export ------------------${Color_Off}"
	tableName=""

	echo "Enter table name"
	read tableName

	while [[ ! -f $tableName ]]; do
		echo -e "${RED}Enter valid table name${Color_Off}"
		read tableName
	done

	timeStamp=$(date +%s)
	fileName=${tableName}${timeStamp}

	echo "Enter your export choice"
	select choice in "Export All" "Export Column" "Export Row" "Table Menu" "Exit"; do
		case $choice in
		"Export All")
			#column -t --> format table with delimiter whitespace, -s --> to specify delimiter

			columns=$(awk -F$separator '{ for(i = 1 ; i <= NF; i++) {if (NR==1) { print $i } } }' $tableName)

			echo $columns
			totalColumns=""
			for col in $columns; do
				totalColumns+=$col","
			done

			# -L is used to print null (empty cells)
			awk 'BEGIN{FS="'$separator'"}{if (NR==1); else print $0}' $tableName | column -s "$separator" -L -J --table-name $tableName --table-columns $totalColumns >../../Exported/$fileName.json 2>>../../.error.log

			if [[ $? == 0 ]]; then
				echo -e "${GREEN}Table Exported Successfully${Color_Off}"
			else
				echo -e "${RED}Something went wrong, Try again later${Color_Off}"
			fi
			tableMenu
			;;

		"Export Column")
			colNumber=0
			counter=0
			colNameCounter=0

			#To retrive columns names
			data=$(awk -F$separator '{ for(i = 1 ; i <= NF; i++) {if (NR==1) { print $i } } }' $tableName)

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

			colName=""

			for column in $data; do
				((colNameCounter++))
				if [[ $colNameCounter == $colNumber ]]; then
					colName=$column
				fi
			done

			timeStamp=$(date +%s)

			# -L is used to print null (empty cells)
			awk 'BEGIN{FS="'$separator'"}{if (NR==1); else print $'$colNumber'}' $tableName | column -s "$separator" -L -J --table-name $tableName --table-columns $colName >../../Exported/$fileName.json 2>>../../.error.log

			if [[ $? == 0 ]]; then
				echo -e "${GREEN}Table Exported Successfully${Color_Off}"
			else
				echo -e "${RED}Something went wrong, Try again later${Color_Off}"
			fi

			tableMenu
			;;

		"Export Row")
			counter=0
			choice=0

			#To retrive columns names
			data=$(awk -F$separator '{ for(i = 1 ; i <= NF; i++) {if (NR==1) { print $i } } }' $tableName)

			echo "Enter column name"

			for column in $data; do
				((counter++))
				echo "$counter. To select $column"
			done

			read choice

			while [[ ! $choice =~ ^[1-$counter]$ ]]; do
				echo -e "${RED}Enter valid choice${Color_Off}"
				read choice
			done

			echo "Enter value to search"
			read searchVal

			totalColumns=""
			for col in $data; do
				totalColumns+=$col","
			done

			# -L is used to print null (empty cells)
			awk 'BEGIN{FS="'$separator'"}{if ( $'$choice' == "'$searchVal'" ) print $0 }' $tableName | column -s "$separator" -L -J --table-name $tableName --table-columns $totalColumns >../../Exported/$fileName.json 2>>../../.error.log

			if [[ $? == 0 ]]; then
				echo -e "${GREEN}Table Exported Successfully${Color_Off}"
			else
				echo -e "${RED}Something went wrong, Try again later${Color_Off}"
			fi

			tableMenu
			;;

		"Table Menu") tableMenu ;;
		"Exit")
			exitFromSubTable
			exit
			;;
		*)
			echo -e "${RED}Invalid choice${Color_Off}"
			;;
		esac
	done
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
	echo "8. Export Table"
	echo "9. Back to main menu"
	echo "10. Exit"

	read choice

	case $choice in
	1) createTable ;;
	2) listTables ;;
	3) dropTable ;;
	4) insert ;;
	5) selectTable ;;
	6) deleteFromTable ;;
	7) updateTable ;;
	8) exportTable ;;
	9) backToMain ;;
	10)
		exitFromSubTable
		exit
		;;
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
