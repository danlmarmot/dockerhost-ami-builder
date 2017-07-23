#!/bin/sh

# Install Docker CE Ubuntu AMI

# set -e

echo --- Running bootstrap_docker_ce.sh ---
sudo apt-get remove docker docker-engine

sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88

sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

# avoid grub prompts to upgrade, see https://askubuntu.com/questions/595458/how-to-auto-answer-apt-get-upgrade
sudo apt-mark hold grub-legacy-ec2

sudo apt-get update
sudo apt-get -y upgrade
sudo apt-get install -y docker-ce

sudo groupadd docker
sudo usermod -aG docker ubuntu
sudo systemctl enable docker
docker --version

# Add AWS ECR Credential Helper
# See https://github.com/awslabs/amazon-ecr-credential-helper

echo --- Adding Docker ECR Login helper ---
sudo cp /tmp/docker-credential-ecr-login /usr/bin/docker-credential-ecr-login
sudo chmod +x /usr/bin/docker-credential-ecr-login
sudo mkdir /root/.docker
sudo echo '{"credsStore":"ecr-login"}' > /root/.docker/config.json

echo --- Adding AWS CloudWatch Logs for $REGION ---
curl -Sso /tmp/awslogs-agent-setup.py https://s3.amazonaws.com//aws-cloudwatch/downloads/latest/awslogs-agent-setup.py
sudo python3 /tmp/awslogs-agent-setup.py --region $REGION --non-interactive --configfile /tmp/awslogs.conf
sudo systemctl enable awslogs

echo --- Adding AWS CLI Tools ---
sudo apt -y install awscli python-pip
sudo -H pip install --upgrade pip
sudo -H pip install --upgrade awscli
sudo -H pip install --upgrade watchtower