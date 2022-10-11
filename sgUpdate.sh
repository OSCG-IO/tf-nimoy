#!/bin/bash
export input="my.out"
source env.sh
source keys/aws-creds.sh

while IFS= read -r line
do
    if [[ $line == driver_public_ip* || $line == node_public_ip* ]]; then
        ip_list="`echo $line | cut -d "=" -f2` $ip_list"
    elif [[ $line == sg_id* ]]; then
        sg_id="`echo $line | cut -d "=" -f2` $sg_id"
    fi
done < "$input"

ip_list=`echo $ip_list | sed 's:,*$::'`
ip_list=`echo $ip_list | sed 's:\"::g'`
sg_id=`echo $sg_id | sed 's:\"::g'`
for sg in $sg_id; do
    for ip in $ip_list; do
        ip=`echo $ip | sed 's/\.[^.]*$//'`.0/32
        aws configure set region "us-west-2"
        aws ec2 authorize-security-group-ingress --group-id $sg --protocol tcp --port 22 --cidr $ip
        aws ec2 authorize-security-group-ingress --group-id $sg --protocol tcp --port 5432 --cidr $ip
        aws ec2 authorize-security-group-ingress --group-id $sg --protocol tcp --port 9187 --cidr $ip
        aws ec2 authorize-security-group-ingress --group-id $sg --protocol icmp --port -1 --cidr $ip
    done
done