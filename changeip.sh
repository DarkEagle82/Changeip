#!/bin/sh
#############################################################################################################
## Program: changeip for changeip.com
## Based on a Eric Ste-marie estemari@sympatico.ca program.
######################################################
## Script to update changeIP dynamic dns to include as a  cron job.
## i.e.: "*/5 * * * * /sbin/SCRIPTNAME" to run it every five minutes
## It uses lynx patched with SSL
## put the script where you want it.
## Adjust the environment variables to suit your needs.
## PATHTOLYNX= patch to lynx. You can try "which lynx" on the command line
##             to find out
## PATHTOCURRENTIP = file where to store the most recent ip
## PATHTOLOGFILE = file where to log information
## USER = Your changeIP username
## PASSWORD = Your changeIP password.  Note that if you want, you could
##            put the password in something like /etc/changeip/secret
##            and set PASSWORD=`cat /etc/changeip/secret`   Don't forget
##            to make this script and that file readable only by root
##            (chmod 700) for obvious reasons.
## CMD = changeIP commmand. update for most of us
## SET = 1
## OFFLINE = 0 (or one to put your domain name to your offline ip.
##
##
##
## Don't forget to chmod 700 the script as you have the password in there.
## (chmod 700 /sbin/SCRIPTNAME)
## Don't forget to chown root:root the script or bin:bin .
## (chown root:root /sbin/SCRIPTNAME)
##
## After you run the script for the first time, remember to verify that the
## log files are NOT readable by anybody else than root, especially if you
## use debug mode (set -x)

# set -x                                    #uncomment to run in debug mode

###############Script variables to set##################################
###############Script variables to set##################################
PATHTOLYNX=/usr/bin/lynx
PATHTOCURRENTIP=/var/log/changeip/ip
PATHTOLOGFILE=/var/log/changeip/cip.log
USER=usuario      #might be case sensitive
PASSWORD=password   #might be case sensitive
CMD=update
SET=1
OFFLINE=0
##########################################################################

umask 177                                    #To set file creation to 600

CURRENTIP=`lynx -dump http://www.mediacollege.com/internet/utilities/show-ip.shtml \ | awk '/is:/{print $NF}'`

grep $CURRENTIP $PATHTOCURRENTIP 1>/dev/null 2>&1
if [ $? -ne 0 ];
then
    $PATHTOLYNX -dump -accept_all_cookies "https://www.changeip.com/update.asp?u=$USER&p=$PASSWORD&cmd=$CMD&set=$SET&offline=$OFFLINE" 1>>$PATHTOLOGFILE
	echo $(date) >> $PATHTOLOGFILE
    echo "$CURRENTIP" > $PATHTOCURRENTIP
fi
                        