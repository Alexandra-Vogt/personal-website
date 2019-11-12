#!/bin/bash

source server.cfg

newVersion=`expr $version + 1`

oldServer=$name-$version
newServer=$name-$newVersion

#delete old instance 
gcloud -q compute instances delete $name-$version\
    --zone $zone

#create new instance
gcloud -q compute instances create $newServer \
    --image-project debian-cloud \
    --image-family  debian-9 \
    --zone $zone \
    --address $ipAddr \
    --machine-type $type

#copy file to instance and execute setup script
gcloud -q compute scp --zone $zone --recurse $PWD/server/* $newServer:~/
gcloud -q compute ssh $newServer --zone $zone -- "sudo ./setup.sh"

#open firewall
gcloud compute instances add-tags $newServer \
    --zone $zone \
    --tags http-server

#replace server.cfg with new config

echo "zone=\"$zone\"
type=\"$type\"
name=\"$name\"
version=\"$newVersion\"
ipAddr=\"$ipAddr\"" | cat > server.cfg
