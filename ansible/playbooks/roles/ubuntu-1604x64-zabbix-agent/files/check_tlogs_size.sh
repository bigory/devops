#!/bin/bash
# 
# Plugin to check free ram space
# using check_by_ssh
# by Markus Walther (voltshock@gmx.de)
# The script needs a working check_by_ssh connection and needs to run on the client to check it
# 
# Command-Line for check_by_ssh
# command_line $USER1$/check_by_ssh -H $HOSTNAME$ -p $ARG1$ -C "$ARG2$ $ARG3$ $ARG4$ $ARG5$ $ARG6$"
# 
# Command-Line for service (example)
# check_by_ssh!82!/nagios/check_ram.sh!20!10
#
##########################################################

case $1 in
  --help | -h )
        echo "Usage: check_tlogs_size [warn] [crit]"
        echo " [warn] and [crit] as int in Mbytes"
        echo " Example: check_ram 20 10"
        exit 3
         ;;
  * )
    ;;
esac

warn=$1
crit=$2

if [ ! "$1" -o ! "$2" ]; then
        echo "Usage: check_tlogs_size [warn] [crit]"
        echo " [warn] and [crit] as int in Mbytes"
        echo " Example: check_tlogs_size 1024 2048"
        echo "Unknown: Options missing: using default (warn=1024, crit=2048)"
        warn=`echo $((1024))`
        crit=`echo $((2048))`
fi

#full=`free | grep Mem | sed -r 's/\ +/\ /g' | cut -d \  -f 2`
#free=`free | grep + | sed -r 's/\ +/\ /g' | cut -d \  -f 3`
use=`du -m /opt/tomcat/current/logs | cut -f 1`

if [ "$warn" -gt "$crit" -o "$warn" -eq "$crit" ]; then
   echo "Unknown: [warn] must be larger than [crit]"
        exit 3
fi

if [ "$use" -lt "$warn" -o "$use" -eq "$warn" ]; then
        echo "OK: $use Mb logs total"
        exit 0
 elif [ "$use" -gt "$warn" -a "$use" -lt "$crit" ]; then
        echo "Warning: $use Mb logs total"
        exit 1
 elif [ "$use" -eq "$crit" -o "$use" -gt "$crit" ]; then
        echo "Critical: $use Mb logs total"
        exit 2
 else
        echo "Unknown"
        exit 3
fi

