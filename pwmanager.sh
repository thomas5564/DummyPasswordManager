#!/bin/bash

if [ "$EUID" -ne 0 ]; then
  echo "This script must be run as root. Please enter your password."
  exec sudo "$0" "$@"
fi

name='pw.csv'
declare -A dict

function scan(){
	while IFS=, read -r col1 col2 col3;do
		dict[$col1]="$col2,$col3"
	done<$name
}
function write(){
	echo "website?"
	read website
	echo "usename?"
	read username
	echo "password?"
	read password
	echo "$website,$username,$password">>$name
}
function show(){
	local website=$1
	keys=${!dict[@]}
	IFS=',' read -r username password <<< "${dict[$website]}"
	if [[ -n "${dict[$website]}" ]];then
		 echo "your username is $username"
		 echo "your password is $password"
		 return 0
	fi
	echo "website not found. typo?"
	return 1
}
scan
while true;do
	echo "welcome to the password manager. press 1 to get your details and 0 to make an entry"
	read choice
	if [[ $choice -eq 1 ]];then
		echo "for which website?"
		for i in "${!dict[@]}"; do
   			 echo -e "$i\n"
		done
		read website
		show $website
		if [ $? -eq 0 ];then
			break
		fi
	else
		while true;do
			write	
			echo "make another [0]"
			echo "thats all for now [1]"
			read choice2
			if [[ $choice2 -eq 1 ]];then
				break
			fi
		done
	fi
done









