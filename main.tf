terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region  = "us-west-2"
}

resource "aws_instance" "node1-1" {
  ami           = "ami-0ee02425a4c7e78bb"
  instance_type = "c6g.large"
  availability_zone = "us-west-2c"
  key_name = "aws-oregon-key"
  tags = {
    Name = "node1-1"
  }
   user_data = <<EOF
#! /bin/bash
  echo "### Set HOSTNAME"
  echo 'node1-1' > /etc/hostname

  echo "### Update the OS w/ Git & Python3"
  sudo apt update -y
  sudo apt install -y wget curl git python3

  echo "Setup /db"
  sudo mkdir /db
  sudo chown ubuntu:ubuntu /db

  echo "### Configure .bashrc"
  echo 'export PATH=$PATH:/db/oscg/pg14/bin'     >> /home/ubuntu/.bashrc

  echo "### Installing IO"
  cd /db
  python3 -c "$(curl -fsSL https://oscg-io-download.s3.amazonaws.com/REPO/install.py)"
  chown -R ubuntu:ubuntu oscg
  cd oscg
  su - ubuntu -c "./io install pg14 --start : tune pg14 : install spock"

  echo "### Generating SSH key"
  cd /home/ubuntu
  echo -e "\n\n\n" | ssh-keygen -t rsa -f /home/ubuntu/.ssh/id_rsa.pub

  touch /home/ubuntu/.ssh/authorized_keys
  chmod 600 /home/ubuntu/.ssh/authorized_keys
  echo '' >> /home/ubuntu/.ssh/authorized_keys

  echo "### rebooting to get new HOSTNAME"
  sudo reboot
EOF

}


resource "aws_instance" "driver1-1" {
  ami           = "ami-0ee02425a4c7e78bb"
  instance_type = "c6g.large"
  availability_zone = "us-west-2c"
  key_name = "aws-oregon-key"
  tags = {
    Name = "driver1-1"
  }
 user_data = <<EOF
#! /bin/bash
  echo "### Set HOSTNAME"
  echo 'driver1-1' > /etc/hostname

  echo "### Update the OS w/ Git, Java & Python3"
  sudo apt update -y
  sudo apt install -y wget git openjdk-11-jdk python3 python3-dev python3-pip
  j_home=/usr/lib/jvm/java-11-openjdk
  arch=`arch`
  if [ "$arch" == "aarch64" ]; then
    j_home=$j_home-arm64
  fi

  echo "### Install Paralell SSH"
  sudo pip3 install git+https://github.com/lilydjwg/pssh

  sudo su - ubuntu

  echo "Install NIMOY"
  cd /home/ubuntu
  rm -rf test
  mkdir -p test/data
  cd test
  ##git clone https://github.com/OSCG-IO/io
  git clone https://github.com/OSCG-IO/nimoy

  echo "Install ANT"
  cd /home/ubuntu
  ANT=apache-ant-1.9.16-bin'
  a_home=/home/ubuntu/$ANT
  rm -f $ANT.tar.gz
  wget http://mirror.olnevhost.net/pub/apache/ant/binaries/$ANT.tar.gz
  tar xf $ANT.tar.gz
  rm $ANT.tar.gz

  echo "### Configure .bashrc"
  echo "export JAVA_HOME=$j_home"                >> /home/ubuntu/.bashrc 
  echo 'export PATH=$PATH:$JAVA_HOME/bin'        >> /home/ubuntu/.bashrc
  echo 'export ANT_HOME=$HOME/apache-ant-1.9.16' >> /home/ubuntu/.bashrc
  echo 'export PATH=$ANT_HOME/bin:$PATH'         >> /home/ubuntu/.bashrc
  echo 'export RMT=$HOME/test/nimoy/remote'      >> /home/ubuntu/.bashrc
  echo 'export PATH=$PATH:$HOME/oscg/pg14/bin'   >> /home/ubuntu/.bashrc

  echo "### Build nimoy locally"
  source .bashrc
  cd /home/ubuntu/test/nimoy/remote
  $a_home/ant clean
  $a_home/ant

  echo "### Installing IO"
  cd /home/ubuntu
  python3 -c "$(curl -fsSL https://oscg-io-download.s3.amazonaws.com/REPO/install.py)"
  cd oscg
  ./io install pg14 --start : stop pg14 

  echo "### Generating SSH key"
  cd /home/ubuntu
  echo -e "\n\n\n" | ssh-keygen -t rsa

  touch .ssh/authorized_keys
  chmod 600 .ssh/authorized_keys
  echo '' >> .ssh/authorized_keys

  echo "### rebooting to get new HOSTNAME"
  sudo reboot
EOF

}

