# AWSR53DDNS
This script is for those who are using AWS Route 53, but doesn't have luxury of static public IP
It can be used on EC2 instance as well (didn't test it so far)
Idea of this project is to run it on any machine behind your nat scheduled by cron
Script is design to update only one record (so far)

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
