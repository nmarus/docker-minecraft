#!/bin/bash

set -e

#description:   timestamp
#usage:         echo ${timestamp}
#returns:       timestamp

timestamp() {
        date +"%Y-%m-%d %T"
}

#description:   script logger
#usage:         sclog <message> [<file>]
#returns:       dated log message

sclog() {
        if [ ! -z ${2+x} ]; then
                #if $2 is existing character file or not exisiting
                if [ -c ${2} ] || [ ! -a ${2} ]; then
                        echo "$(timestamp): ${1}" | tee -a ${2}
                else
                        echo "$(timestamp): ${1}"
                fi
        else
                echo "$(timestamp): ${1}"
        fi
}


#get current minecraft version
sclog "Getting updated minecraft version."
VER=$(wget -q -O - https://s3.amazonaws.com/Minecraft.Download/versions/versions.json | jsawk -n 'out(this.latest.release)')

#set minecraft dir and jar
MCDIR="/data"
MC="$MCDIR/minecraft-server.jar"

#remove current minecraft executable if it exists
if [ -e $MC ]; then
        rm -rf $MC &> /dev/null
fi
        
#get minecraft
sclog "Downloading https://s3.amazonaws.com/Minecraft.Download/versions/$VER/minecraft_server.$VER.jar"
wget -q -O $MC https://s3.amazonaws.com/Minecraft.Download/versions/$VER/minecraft_server.$VER.jar &> /dev/null

#accept eula
echo "eula=true" > $MCDIR/eula.txt

#set permissions
chown -R minecraft:minecraft $MCDIR &> /dev/null

#start minecraft
sclog "Starting minecraft v.$VER..."
cd /data
exec sudo -E -u minecraft java -Xmx1024M -Xms1024M -jar $MC

#exit
sclog "Exiting container..." 
