#!/bin/bash

# Location of the linbpq binary.  Depends on $PATH as shown.
# change this if you want to use some other specific location.
# e.g.  LINBPQ="/usr/local/bin/linbpq"

# User login name ATTENTION: this is case sensitive!!!
USERNAME="ENTER_YOUR_USERNAME_HERE"

# Path to the linbpq directory
LINBPQPATH="/home/${USERNAME}/linbpq"

# Name of linbpq binary
LINBPQ_BIN="linbpq"

# -----------------------------------------------------------
# Main Script start
# -----------------------------------------------------------

# When running from cron, we have a very minimal environment
# including PATH=$LINBPQPATH

export PATH=$LINBPQPATH:$PATH


# First wait a little while in case we just rebooted
# and it has not had time to finish booting.
#
sleep 3


#
# Nothing to do if linbpq is already running.
#

pgrep $LINBPQ_BIN
# pgrep returns 0 to $? if app is running 1 if not
if [ $? -eq 0 ] 
then
  echo "LINBPQ already running, exiting script"
  exit
fi
  
# Not running, start it up
echo "Starting LINBPQ..."

# Must run linbpq from the directory it's in, so switch to it
cd $LINBPQPATH
# Then run it
$LINBPQPATH/$LINBPQ_BIN


