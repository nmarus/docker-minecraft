#!/bin/bash
#Startup script for minecraft
#https://github.com/nmarus/docker-minecraft
#nmarus@gmail.com

set -e

QUIET=false
#SFLOG="/start.log"

#print timestamp
timestamp() {
	date +"%Y-%m-%d %T"
}

#screen/file logger
sflog() {
	#if $1 is not null
	if [ ! -z ${1+x} ]; then
		message=$1
	else
		#exit function
		return 1;
	fi
	#if $QUIET is not true
	if ! $($QUIET); then
		echo "${message}"
	fi
	#if $SFLOG is not null
	if [ ! -z ${SFLOG+x} ]; then
		#if $2 is regular file or does not exist
		if [ -f ${SFLOG} ] || [ ! -e ${SFLOG} ]; then
			echo "$(timestamp) ${message}" >> ${SFLOG}
		fi
	fi
}

#get current minecraft version
sflog "Getting updated minecraft version."
VER=$(wget -q -O - https://s3.amazonaws.com/Minecraft.Download/versions/versions.json | jsawk -n 'out(this.latest.release)')

#set minecraft dir and jar
MCDIR="/minecraft"
MCJAR="$MCDIR/minecraft-server.jar"

#remove current minecraft executable if it exists
if [ -e $MCJAR ]; then
  rm -rf $MCJAR &> /dev/null
fi

#get minecraft
sflog "Downloading https://s3.amazonaws.com/Minecraft.Download/versions/$VER/minecraft_server.$VER.jar"
wget -q -O $MCJAR https://s3.amazonaws.com/Minecraft.Download/versions/$VER/minecraft_server.$VER.jar &> /dev/null

#accept eula
echo "eula=true" > $MCDIR/eula.txt

#set permissions
chown -R minecraft:minecraft $MCDIR &> /dev/null

#start minecraft
sflog "Starting minecraft v.$VER..."
cd $MCDIR
exec sudo -E -u minecraft java -Xmx1024M -Xms1024M -jar $MCJAR

#exit
sflog "Exiting container..."
