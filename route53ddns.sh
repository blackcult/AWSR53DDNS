#!/bin/bash

#log file adjustment
LOG_FILE="/var/log/rout53ddns.log"
exec 3>&1 1>>${LOG_FILE} 2>&1
echo " " 
echo " "
echo "NEW RUN" 
echo "at $(date)"


# Your public IP
VALUE=$(curl -s https://checkip.amazonaws.com)

#Arguments
for i in "$@"
do
case $i in
    -t=*)
    TYPE="${i#*=}"
    shift 
    ;;
	-a)
    AWS="A"
    shift 
    ;;
    -n=*)
    NAME="${i#*=}"
    shift 
    ;;
    -i=*)
    HOSTZONEID="${i#*=}"
    shift 
    ;;
	-o=*)
    VALUE="${i#*=}"
    shift 
    ;;
	-p=*)
    PROFILE="${i#*=}"
    shift 
    ;;
    *)
          
    ;;
esac
done


if [[ -n $1 ]]; then
	echo ""
	tail -1 $1
fi


if [ -z "$TYPE" -a -z "$NAME" -a -z "$HOSTZONEID" ]; then
	echo "Missing arguments" 1>&3
	echo "Missing arguments"
	echo '"-t=" with record type (A,CNAME,...) (needed)' 1>&3
	echo '"-n=" with record name (FQDN) (needed)' 1>&3
	echo '"-i=" for hostzone ID (needed)' 1>&3
	echo '"-p=" AWS profile, if not set script will use default (optional)' 1>&3
	echo '"-o=" with an IP address to overwrite(test) with different IP then your public (optional)' 1>&3
	echo '"-a=" if you are using it on EC2 instance with IAM role. Will remove --profile from AWSCLI part' 1>&3
	echo "_____________________"
	exit 1
fi


if [ -z "$PROFILE" ]; then
	PROFILE="default"
fi


if [ -z $AWS ]; then
	AWSPROFILE="--profile $PROFILE"
else
	AWSPROFILE=""
	echo "If you are using -a its better to use IAM role then user profile :)"
fi

#Current IP of the domain/subdomain - if exists
CURRENTIP=$(nslookup $NAME 8.8.8.8 | awk -F': ' 'NR==6 { print $2 } ')

#Work with the json file + validation if there is a action needed
if [[ $VALUE != $CURRENTIP ]]; then
	sed -e "s/name_var/$NAME/g" -e "s/type_var/$TYPE/g" -e "s/value_var/$VALUE/g" entry.json > entrytemp.json
	aws route53 "$AWSPROFILE" change-resource-record-sets --hosted-zone-id "$HOSTZONEID" --change-batch file://entrytemp.json
	#checking for error output from AWSCLI
	if [ $? -eq 0 ]; then
		echo "Changing IP from $CURRENTIP to $VALUE"
		echo "Changing IP from $CURRENTIP to $VALUE" 1>&3
		echo "_____________________"
		exit 1;
	else
		echo "error, check logs" 1>&3
		echo "_____________________"
		exit 1;
	fi
else
	echo "IP didn't change. Still same old $CURRENTIP"
	echo "IP didn't change. Still same old $CURRENTIP" 1>&3
	echo "_____________________"
	exit 1;
fi
