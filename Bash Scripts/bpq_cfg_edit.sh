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

echo Enter your callsign:

read USER_CALL

echo  

echo Enter a Node Alias (up to 6 chars):

read NODE_ALIAS

echo $USER_CALL $NODE_ALIAS