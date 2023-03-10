#!/bin/bash

# install figlet
# blue "$(figlet -c -f big "iti DBMS !")" > DBMS.txt

# RED_B='\e[1;91m'
# GREEN_B='\e[1;92m'
# YELLOW_B='\e[1;93m'
# BLUE_B='\e[1;94m'
# PURPLE_B='\e[1;95m'
# CYAN_B='\e[1;96m'
# WHITE_B='\e[1;97m'
# RESET='\e[0m'

# red() { echo -e "${RED_B}${1}${RESET}"; }
# green() { echo -e "${GREEN_B}${1}${RESET}"; }
# yellow() { echo -e "${YELLOW_B}${1}${RESET}"; }
# blue() { echo -e "${BLUE_B}${1}${RESET}"; }
# purple() { echo -e "${PURPLE_B}${1}${RESET}"; }
# cyan() { echo -e "${CYAN_B}${1}${RESET}"; }
# white() { echo -e "${WHITE_B}${1}${RESET}"; }

#  --------------------  Colors Map ----------------------
# Octal Colors
#  ┌───────┬─────────────────┬──────────┐   ┌───────┬─────────────────┬──────────┐
#  │ Code  │ Style           │ Octal    │   │ Code  │ Style           │ Octal    │
#  ├───────┼─────────────────┼──────────┤   ├───────┼─────────────────┼──────────┤
#  │   -   │ Foreground      │ \033[3.. │   │   B   │ Bold            │ \033[1m  │
#  │   _   │ Background      │ \033[4.. │   │   U   │ Underline       │ \033[4m  │
#  ├───────┼─────────────────┼──────────┤   │   F   │ Flash/blink     │ \033[5m  │
#  │   k   │ Black           │ ......0m │   │   N   │ Negative        │ \033[7m  │
#  │   r   │ Red             │ ......1m │   ├───────┼─────────────────┼──────────┤
#  │   g   │ Green           │ ......2m │   │   L   │ Normal (unbold) │ \033[22m │
#  │   y   │ Yellow          │ ......3m │   │   0   │ Reset           │ \033[0m  │
#  │   b   │ Blue            │ ......4m │   └───────┴─────────────────┴──────────┘
#  │   m   │ Magenta         │ ......5m │
#  │   c   │ Cyan            │ ......6m │
#  │   w   │ White           │ ......7m │
#  └───────┴─────────────────┴──────────┘

# ------------------------ Colors plate --------------------------
# # Reset
# Color_Off='\033[0m'       # Text Reset

# # Regular Colors
# Black='\033[0;30m'        # Black
# Red='\033[0;31m'          # Red
# Green='\033[0;32m'        # Green
# Yellow='\033[0;33m'       # Yellow
# Blue='\033[0;34m'         # Blue
# Purple='\033[0;35m'       # Purple
# Cyan='\033[0;36m'         # Cyan
# White='\033[0;37m'        # White

# # Bold
# BBlack='\033[1;30m'       # Black
# BRed='\033[1;31m'         # Red
# BGreen='\033[1;32m'       # Green
# BYellow='\033[1;33m'      # Yellow
# BBlue='\033[1;34m'        # Blue
# BPurple='\033[1;35m'      # Purple
# BCyan='\033[1;36m'        # Cyan
# BWhite='\033[1;37m'       # White

# # Underline
# UBlack='\033[4;30m'       # Black
# URed='\033[4;31m'         # Red
# UGreen='\033[4;32m'       # Green
# UYellow='\033[4;33m'      # Yellow
# UBlue='\033[4;34m'        # Blue
# UPurple='\033[4;35m'      # Purple
# UCyan='\033[4;36m'        # Cyan
# UWhite='\033[4;37m'       # White

# # Background
# On_Black='\033[40m'       # Black
# On_Red='\033[41m'         # Red
# On_Green='\033[42m'       # Green
# On_Yellow='\033[43m'      # Yellow
# On_Blue='\033[44m'        # Blue
# On_Purple='\033[45m'      # Purple
# On_Cyan='\033[46m'        # Cyan
# On_White='\033[47m'       # White

# # High Intensity
# IBlack='\033[0;90m'       # Black
# IRed='\033[0;91m'         # Red
# IGreen='\033[0;92m'       # Green
# IYellow='\033[0;93m'      # Yellow
# IBlue='\033[0;94m'        # Blue
# IPurple='\033[0;95m'      # Purple
# ICyan='\033[0;96m'        # Cyan
# IWhite='\033[0;97m'       # White

# # Bold High Intensity
# BIBlack='\033[1;90m'      # Black
# BIRed='\033[1;91m'        # Red
# BIGreen='\033[1;92m'      # Green
# BIYellow='\033[1;93m'     # Yellow
# BIBlue='\033[1;94m'       # Blue
# BIPurple='\033[1;95m'     # Purple
# BICyan='\033[1;96m'       # Cyan
# BIWhite='\033[1;97m'      # White

# # High Intensity backgrounds
# On_IBlack='\033[0;100m'   # Black
# On_IRed='\033[0;101m'     # Red
# On_IGreen='\033[0;102m'   # Green
# On_IYellow='\033[0;103m'  # Yellow
# On_IBlue='\033[0;104m'    # Blue
# On_IPurple='\033[0;105m'  # Purple
# On_ICyan='\033[0;106m'    # Cyan
# On_IWhite='\033[0;107m'   # White





RED='\033[0;31m'
GREEN='\033[0;32m'
ORANGE='\033[0;33m'
Color_Off='\033[0m'
Blue='\033[0;34m' 
Yellow='\033[0;33m'
HEAD_BLUE='\033[37;44;1m'
CELL_BLUE='\033[37;104;1m'
CELL_GREY='\033[37;107;1m'
Cyan='\033[0;36m'