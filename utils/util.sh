#!/bin/bash

function exitProgram {
	cat exit.txt 2>>.error.log
	echo -e "\n"
	echo -e "* Contact Us${Blue} \e]8;;${AUTHOR_ONE_LINKEDIN}\a${AUTHOR_ONE}\e]8;;\a ${Color_Off}, ${Blue} \e]8;;${AUTHOR_TWO_LINKEDIN}\a${AUTHOR_TWO}\e]8;;\a ${Color_Off}"
}

function exitFromSubTable {
	cat ../../exit.txt 2>>.error.log
	echo -e "\n"
	echo -e "* Contact Us${Blue} \e]8;;${AUTHOR_ONE_LINKEDIN}\a${AUTHOR_ONE}\e]8;;\a ${Color_Off}, ${Blue} \e]8;;${AUTHOR_TWO_LINKEDIN}\a${AUTHOR_TWO}\e]8;;\a ${Color_Off}"
}
