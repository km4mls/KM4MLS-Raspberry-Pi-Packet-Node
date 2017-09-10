#!/bin/bash

# Author   : Brian Edmonson, KM4MLS
# Date	   : 9-9-17
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



# Defines
LINBPQDIR="/home/${USER}/linbpq/" 
BPQCFG="bpq32.cfg"

# Variables
PASS_INVALID='0'
RESPONSE_INVALID='0'
GRID_INVALID='0'
FREQUENCY_INVALID='0'

#######################################################################
#  Function    : header                                               #
#                                                                     #
#  Description : Displays the script title at the top of the terminal #
#                while running the set-up script.                     #
#                                                                     #
#######################################################################
function header {
clear
echo '+------------------------------------------------------------+'
echo '|             BPQ32.cfg Set-Up Script by KM4MLS              |'
echo '+------------------------------------------------------------+'
echo 
echo '          Press [CTRL] + C  at any time to quit'
echo
echo

}
#### END header FUNCTION


#######################################################################
#  Function    : get_grid_square                                      #
#                                                                     #
#  Description : Gets the user's madienhead grid square locator       #
#                for use on the BPQ32 node map and is also used       #
#                in the Beacon Text.                                  #
#                                                                     #
#######################################################################
function get_grid_square {
# Get user's gridsquare
header
echo 'Enter your gridsquare locator (this is for the node map):'
echo '(ex: EM82dk)'
if [ $GRID_INVALID == '1' ]
then
	echo
	echo 'Invalid response. Please enter your full six character'
	echo 'maidenhead grid square locator'
	echo
fi
read GRID_SQUARE

# Check for full gridsquare
	GRIDLEN="${#GRID_SQUARE}"
	if [ $GRIDLEN != '6' ]
	then 
		GRID_INVALID='1'
		get_grid_square
		
	fi
GRID_INVALID='0'

# Seperate base gridsquare and suffix 
GRID_SQUARE_PRE="${GRID_SQUARE:0:4}" 
GRID_SQUARE_SUF="${GRID_SQUARE:4:2}"

# Convert base gridsquare to uppercase and suffix to lower (standard notation)
GRID_SQUARE="${GRID_SQUARE_PRE^^}${GRID_SQUARE_SUF,,}"
} 
### END get_grid_square FUNCTION

function get_frequency {
# Get user's frequency of operation 
header
echo 'Enter the radio frequency (in Mhz) you plan to operate on in Mhz (this is used for the beacon text and info text):'
echo '(ex: 145.010)'
	if [ $FREQUENCY_INVALID == '1' ]
	then
		echo
		echo 'Invalid frequency entered, frequency must be between 144.1-148 or 420-450'
		echo
	fi
read FREQUENCY
	#if [ $FREQUENCY -gt 144 ]  && [ $FREQUENCY -lt 148 ] || [ $FREQUENCY -gt 420 ] && [ $FREQUENCY -lt 450 ]
	
	#FV=$?
	if [ $(echo "$FREQUENCY >= 144.1" | bc) -eq 1 ] && [ $(echo "$FREQUENCY <= 148" | bc) -eq 1 ] || [ $(echo "$FREQUENCY >= 420" | bc) -eq 1 ] && [ $(echo "$FREQUENCY <= 450" | bc) -eq 1 ]
	  #   [ $(echo "$ROTATION == 90" | bc) -eq 1 ]
		then
		FREQUENCY_INVALID='0'
   
	else
		FREQUENCY_INVALID='1'
	
		get_frequency

	fi
	
echo

}

#######################################################################
#  Function    : get_user_info                                        #
#                                                                     #
#  Description : Gathers all the user information needed to configure #
#                the BPQ32.cfg file for a simple station with a BBS,  #
#                Chat, and RMS node.                                  #
#                                                                     #
#######################################################################
function get_user_info {

# Get users callsign
header

echo 'Enter your callsign:'
echo '(ex: KM4MLS)'
read USER_CALL
# Convert to all uppercase 
USER_CALL="${USER_CALL^^}"
echo

#  Get user's maidenhead grid square locator
get_grid_square

# Get user's city
header
echo 'Enter the city/town the node will be located:'
echo '(ex: Perry)'
read CITY
CLEN="${#CITY}"-1
CCAP="${CITY:0:1}"; CCAP="${CCAP^^}"
CEND="${CITY:1:CLEN}"; CEND="${CEND,,}"
CITY="${CCAP}${CEND}"
echo

# Get user's state
header
echo 'Enter the abreviation for the state the node will be located:'
echo '(ex: GA)'
read STATE
# Convert to all uppercase 
STATE="${STATE^^}"
echo

# Get user's frequency of operation
get_frequency

# Get user's desired node alias
header
echo 'Enter an alias call for your node (up to 6 chars):'
echo '(ex: MLSPAC)'
read NODE_ALIAS
# Convert to all uppercase 
NODE_ALIAS="${NODE_ALIAS^^}"
echo

# Get user's desired BBS node alias
header
echo 'Enter an alias call for your BBS/Maildrop node (up to 6 chars):'
echo '(ex: MLSBBS)'
read BBS_ALIAS
# Convert to all uppercase 
BBS_ALIAS="${BBS_ALIAS^^}"

echo

# Get user's desired Chat node alias
header
echo 'Enter an alias call for your Chat node (up to 6 chars):'
echo '(ex: MLSCHT)'
read CHT_ALIAS
# Convert to all uppercase 
CHT_ALIAS="${CHT_ALIAS^^}"
echo

# Get user's desired RMS node alias
header
echo 'Enter an alias call for your Winlink RMS node (up to 6 chars):'
echo '(ex: MLSRMS)'
read RMS_ALIAS
# Convert to all uppercase 
RMS_ALIAS="${RMS_ALIAS^^}"

echo

} 
#### END get_user_info FUNCTION



function get_user_pass {
# Get user's desired password for BPQ

header
	if [ $PASS_INVALID == '1' ]
	then
		echo "password did not match"
	fi
echo 'Enter a password for the Sysop:'
read -s PASS1
echo
echo 'Re-Enter Sysop password:'
read -s PASS2
echo
echo 

	if [ $PASS1 != $PASS2 ]
	then
	echo
	echo 
	echo 'Password does not match!'
	PASS_INVALID='1'
	get_user_pass
	fi
PASS_INVALID='0'
} #END get_user_pass



#######################################################################
#  Function    : confirm_info                                         #
#                                                                     #
#  Description : Reads back user input and confirms that all          #
#                is correct.  If not, jumps back to get_user_info     #
#                and allows user to re-enter their info.              #
#                                                                     #
#######################################################################
function confirm_info {

header
echo
echo 'Station Info:'
echo '-----------------------------------------------'
echo
echo "Callsign   :  $USER_CALL"
echo "Gridsquare :  $GRID_SQUARE"
echo "City       :  $CITY"
echo "State      :  $STATE"
echo "Node Alias :  $NODE_ALIAS"
echo "BBS Alias  :  $BBS_ALIAS"
echo "Chat Alias :  $CHT_ALIAS"
echo "RMS Alias  :  $RMS_ALIAS"
echo "Sysop Pass :  $PASS1"

echo
echo "Is this correct? (y/n):"
echo
	if [ $RESPONSE_INVALID == '1' ]
	then
		echo "Please enter a valid response"
	fi
read INPUT_CORRECT 


# Convert input to all lowercase
INPUT_CORRECT="${INPUT_CORRECT,,}"
#	Check for a valid response
	# If yes ontinue
	if [ $INPUT_CORRECT == 'y' ] || [ $INPUT_CORRECT == 'yes' ]
	then
		# If info is correct, continue
		echo
	elif [ $INPUT_CORRECT == 'n' ] || [ $INPUT_CORRECT == 'no' ]
	then
		# If not, ask again
		loop
		
	else
		# If user entered anything else, inform of invalid response and ask again
		RESPONSE_INVALID='1'
		confirm_info
		
	fi
RESPONSE_INVALID='0'
}
#### END confirm_info FUNCTION



#######################################################################
#  Function    : get_cfg_file                                         #
#                                                                     #
#  Description : Looks for BPQ32.cfg and makes a backup if found,     #
#                then downloads a fresh copy of the starter file      #
#                from the github repository.                          #
#                                                                     #
#######################################################################
function get_cfg_file {
header

# Move to the linbpq directory
cd $LINBPQDIR 

echo 'Looking for an existing copy of BPQ32.cfg...'
sleep 1
# Check if BPQ32.cfg already exists. If so back it up.
if [ -e $LINBPQDIR$BPQCFG ]
then
	echo "Backing up existing BPQ32.cfg file to BPQ32.cfg.bak..."
	cp -f $BPQCFG $BPQCFG.bak
	sleep 2
else
# If not, go ahead and download a copy
	echo "No existing BPQ32.cfg file found..."
	sleep 2
fi

# Download BPQ32.cfg from github
echo "Downloading BPQ32.cfg from github, please wait..."
sleep 2
sudo wget https://github.com/km4mls/KM4MLS-Raspberry-Pi-Packet-Node/raw/master/config/BPQ32.cfg
	if [ $? != 0 ]
	then
		echo 'BPQ32.cfg download failed, exiting set-up'
		cd ~
		sleep 4
		exit	
	fi
	if [ $? == 0 ]
	then
		echo 'Download success!'
		echo "${BPQCFG} saved to ${LINBPQDIR}${BPQCFG}"
		sleep 4
	fi
cd ~
}
#### END get_cfg_file FUNCTION



#######################################################################
#  Function    : edit_cfg                                             #
#                                                                     #
#  Description : Edits the new copy of the BPQ32.cfg file with the    #
#                user supplied details collected in get_user_info     #
#                                                                     #
#                                                                     #
#######################################################################
function  edit_cfg {
echo "Editing ${BPQCFG} ..."
# Now we have a copy of BPQ32.cfg let's make the modifications


# First  replace all copies of NOCALL with the user's callsign

SEARCH="SETUP-NOCALL"
REPLACE=$USER_CALL
run_sed
SEARCH="SETUP-GRIDSQUARE"
REPLACE=$GRID_SQUARE
run_sed
SEARCH="SETUP-CITY"
REPLACE=$CITY
run_sed
SEARCH="SETUP-STATE"
REPLACE=$STATE
run_sed
SEARCH="SETUP-NODEALIAS"
REPLACE=$NODE_ALIAS
run_sed
SEARCH="SETUP-BBSALIAS"
REPLACE=$BBS_ALIAS
run_sed
SEARCH="SETUP-CHATALIAS"
REPLACE=$CHT_ALIAS
run_sed
SEARCH="SETUP-RMSALIAS"
REPLACE=$RMS_ALIAS
run_sed
SEARCH="SETUP-FREQUENCY"
REPLACE=$FREQUENCY
run_sed
SEARCH="SETUP-PASSWORD"
REPLACE=$PASS1
run_sed
# SETUP-NOCALL
# SETUP-GRIDSQUARE
# SETUP-PASSWORD
# SETUP-FREQUENCY
# SETUP-NODEALIAS
# SETUP-BBSALIAS
# SETUP-CHATALIAS
# SETUP-RMSALIAS
# SETUP-CITY
# SETUP-STATE

#sed -i "s/${SEARCH}/${REPLACE}/g" $LINBPQDIR$BPQCFG
sleep 3
echo "Done!"
sleep 1
}
#### END edit_cfg FUNCTION


function run_sed {
sed -i "s/${SEARCH}/${REPLACE}/g" $LINBPQDIR$BPQCFG
}

# "Callsign   :  $USER_CALL"
# "Gridsquare :  $GRID_SQUARE"
# "City       :  $CITY"
# "State      :  $STATE"
# "Node Alias :  $NODE_ALIAS"
# "BBS Alias  :  $BBS_ALIAS"
# "Chat Alias :  $CHT_ALIAS"
# "RMS Alias  :  $RMS_ALIAS"
# "Frequency  :  $FREQUENCY
# "Sysop Pass :  $PASS1



function get_dependencies {
sudo apt-get install bc
}


#######################################################################
#  Function    : loop                                                 #
#                                                                     #
#  Description : Main program loop                                    #
#                                                                     #
#                                                                     #
#######################################################################
function loop {
#get_dependencies
get_user_info
get_user_pass
confirm_info
get_cfg_file
edit_cfg
}
#### END loop FUNCTION



# Start of program 

loop


