#!/usr/bin/env bash

updateServer () {
    # Update server
    sudo apt-get -y update
    sudo apt-get -y upgrade
}

installNode () {
    curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
    sudo apt-get install -y gcc g++ make
    sudo npm install -g npm
    
    curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
    sudo apt-get update
    sudo apt-get install -y yarn

}


installDocker () {
    # Remove old docker versions
    sudo apt-get -y remove docker docker-engine docker.io containerd runc
    # Install docker requirements
    sudo apt-get -y install \
	 apt-transport-https \
	 ca-certificates \
	 curl \
	 gnupg2 \
	 software-properties-common
    # Install Key
    curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
    # Add Repo
    sudo add-apt-repository \
	 "deb [arch=amd64] https://download.docker.com/linux/debian \
   	$(lsb_release -cs) \
   	stable"
    # Update APT
    sudo apt-get -y update
    # Install docker
    sudo apt-get -y install docker-ce docker-ce-cli containerd.io
}

updateServer
installNode
installDocker

yarn global add wetty

# Make docker run 

#build docker
docker build -t "vogt-systems" .
#startup
sudo bash -c nohup \
     wetty --port 80 --command docker run -it --rm vogt-systems /bin/ash --login &
