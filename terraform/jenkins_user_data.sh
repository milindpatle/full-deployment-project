#!/bin/bash
apt update -y
apt install openjdk-11-jdk -y
apt install docker.io -y
systemctl enable docker
systemctl start docker

# Jenkins install
wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | apt-key add -
sh -c 'echo deb https://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
apt update -y
apt install jenkins -y

usermod -aG docker jenkins
systemctl enable jenkins
systemctl start jenkins
