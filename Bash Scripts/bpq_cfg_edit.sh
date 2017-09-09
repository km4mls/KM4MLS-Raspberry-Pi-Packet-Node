#!/bin/bash

# Author   : Brian Edmonson, KM4MLS
# Date	   : 9-8-17
# Modified :
#
# Description:  This script modifies the BPQ32.cfg starter file supplied
#				in the KM4MLS-Raspberry-Pi-Packet-Node github repository.
#				It is designed to make getting LINBPQ (BPQ32) set-up
#				reletively easy and strait-forward. 
#
#				The script asks the user for his/her callsign and other
#		 		relevent information related to the config of BPQ, then 
#				replaces the parts of the BPQ32.cfg that must be unique
#				for each node.

# Variables
INPUT='n'


echo '+--------------------------------------+'
echo '|    KM4MLS BPQ32.cfg Set-Up Script    |'
echo '+--------------------------------------+'
echo

function get_user_info {
# Get users callsign
echo 'Enter your callsign:'
echo '(ex: KM4MLS)'
read USER_CALL
USER_CALL = ${USER_CALL^^}
echo $USER_CALL

# Get user's desired node alias
echo 'Enter a Node Alias "nickname" (up to 6 chars):'
echo '(ex: MLSPAC)'
read NODE_ALIAS
echo

# Get user's gridsquare
echo 'Enter your gridsquare locator (this is for the node map):'
echo '(ex: EM82dk)'
read GRID_SQUARE
echo
} # END get_user_info


function get_user_pass {
# Get user's desired password for BPQ
echo 'Enter a password for the Sysop:'
echo
read -sp 'enter a password: ' pass1
echo
read -sp 're-enter password: ' pass2
echo
echo

	if [ $pass1 != $pass2 ]
	then
	echo
	echo 'Password does not match!'
	get_user_pass
	fi

} #END get_user_pass

function read_back {
echo Callsign	: $USER_CALL
echo Node Alias	: $NODE_ALIAS
echo
echo 'Is this correct? (y/n):'
echo
read 

	#if [ $yn = 'y' ]
	#then
	
	#fi
}

get_user_info
get_user_pass
read_back



