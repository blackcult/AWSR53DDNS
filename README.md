# AWSR53DDNS
This script is for those who are using AWS Route 53, but doesn't have luxury of static public IP
It can be used on EC2 instance as well
Idea of this project is to run it on any machine behind your nat scheduled by cron
Script is design to update only one record (so far)

Tested on Ubuntu 18.04

## Requirments 
User with these policies for Route53
ListHostedZones
ChangeResourceRecordSets (on your host ID)

## Assumtions
Script assumpts you have already AWS CLI and profile setup. By default it guests the default profile

## Arguments
### Mandatory (script will fail if any of those is missing)
"-t=" with record type (A,CNAME,...)
 
"-n=" with record name (FQDN)
 
"-i=" for hostzone ID
 
### Optional
"-p=" AWS profile, if not set script will use default
 
"-o=" with an IP address to overwrite(test) with different IP then your public one

"-a=" if you are using it on EC2 instance with IAM role. Will remove --profile from AWSCLI part

## Example
### Classic use
./route53ddns.sh -t=A -n=subdomain.domain.com -i=45EWFE44545G 
### Troubleshooting with -o option
./route53ddns.sh -t=A -n=subdomain.domain.com -i=45EWFE44545G -o=8.8.8.8
### Running on EC2 instance with IAM role with ChangeResourceRecordSets and ListHostedZones rights
./route53ddns.sh -t=A -n=subdomain.domain.com -i=45EWFE44545G -o=8.8.8.8 -a
