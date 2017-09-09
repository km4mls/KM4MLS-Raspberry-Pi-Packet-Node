#!/bin/bash

# Author   : Brian Edmonson, KM4MLS
# Date	   : 9-8-17
# Revision : 0.1 ALPHA
# Modified :
#
# Description:  This script modifies the BPQ32.cfg starter file supplied
#               in the KM4MLS-Raspberry-Pi-Packet-Node github repository.
#               It is designed to make getting LINBPQ (BPQ32) set-up
#               reletively easy and strait-forward.
#
#               The script asks the user for his/her callsign and other
#               relevent information related to the config of BPQ, then 
#               replaces the parts of the BPQ32.cfg that must be unique
#               for each node.
#
# Notes:        This script is currently in the alpha stage. It does not
#               edit or modify any system files, but with that said, run
#               at your own risk.




# Variables
INPUT_CORRECT='n'
ERROR_TEXT='\033[0;31m'
DEFAULT_TEXT='\033[0m'
PASS_INVALID='0'

function header {
echo '+--------------------------------------+'
echo '|    KM4MLS BPQ32.cfg Set-Up Script    |'
echo '+--------------------------------------+'
echo
}

function get_user_info {
clear 
header
# Get users callsign
echo 'Enter your callsign:'
echo '(ex: KM4MLS)'
read USER_CALL
# Convert to all uppercase 
USER_CALL="${USER_CALL^^}"
echo

clear
header
# Get user's gridsquare
echo 'Enter your gridsquare locator (this is for the node map):'
echo '(ex: EM82dk)'
read GRID_SQUARE
echo

clear
header
# Get user's desired node alias
echo 'Enter an alias call for your node (up to 6 chars):'
echo '(ex: MLSPAC)'
read NODE_ALIAS
echo

clear
header
# Get user's desired BBS node alias
echo 'Enter an alias call for your BBS/Maildrop node (up to 6 chars):'
echo '(ex: MLSBBS)'
read BBS_ALIAS
echo

clear
header
# Get user's desired Chat node alias
echo 'Enter an alias call for your Chat node (up to 6 chars):'
echo '(ex: MLSCHT)'
read CHT_ALIAS
echo

clear
header
# Get user's desired RMS node alias
echo 'Enter an alias call for your Winlink RMS node (up to 6 chars):'
echo '(ex: MLSRMS)'
read RMS_ALIAS
echo

} #### END get_user_info


function get_user_pass {
# Get user's desired password for BPQ
clear
header
	if [ $PASS_INVALID=='1' ]
	then
		echo "${ERROR_TEXT} password did not match ${DEFAULT_TEXT}"
	fi
echo 'Enter a password for the Sysop:'
read -s pass1
echo
echo 'Re-Enter Sysop password:'
read -s pass2
echo
echo 

	if [ $pass1 != $pass2 ]
	then
	echo
	echo 
	echo 'Password does not match!'
	PASS_INVALID='1'
	get_user_pass
	fi
PASS_INVALID='0'
} #END get_user_pass

function read_back {
clear
header
echo Callsign	: $USER_CALL
echo Node Alias	: $NODE_ALIAS
echo
echo 'Is this correct? (y/n):'
echo
read INPUT_CORRECT 
# Convert input to all lowercase
INPUT_CORRECT="${INPUT_CORRECT,,}"
	# Check for a valid response
	if [ INPUT_CORRECT!='y' ] && [ INPUT_CORRECT!='n' ]
	then
		echo 'Invalid option'
		echo
		read_back
	fi
		# If we have a valid response check yes or no
		if [ INPUT_CORRECT!='y' ]
		then
			main
		fi

}

function main {
get_user_info
get_user_pass
read_back
}


main


