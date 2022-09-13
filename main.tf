
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

locals {
  driver = format("%s%s", "driver", var.nn)
  node   = format("%s%s", "node",   var.nn)
}


provider "aws" {
  region  = var.rgn
}

resource "aws_instance"  "node" {
  ami           = var.image
  instance_type = var.type
  availability_zone = var.az
  key_name = var.key
  tags = {
    Name = local.node
  }
   user_data = <<EOF
#! /bin/bash
  echo "### Set HOSTNAME"
  echo "${local.node}" > /etc/hostname

  echo "### Update the OS w/ Git & Python3"
  sudo apt update -y
  sudo apt upgrade -y
  sudo apt install -y wget curl python3 net-tools golang

  echo "Setup /db"
  sudo mkdir /db
  sudo chown ubuntu:ubuntu /db

  echo "### Configure .bashrc"
  echo 'export PATH=$PATH:/db/oscg/pg14/bin'     >> /home/ubuntu/.bashrc

  echo "### rebooting to get new HOSTNAME"
  sudo reboot
EOF

}


resource "aws_instance" "driver" {
  ami           = var.image
  instance_type = var.type
  availability_zone = var.az
  key_name = var.key
  tags = {
    Name = local.driver
  }
 user_data = <<EOF
#! /bin/bash
  echo "### Set HOSTNAME"
  echo "${local.driver}" > /etc/hostname

  echo "### Update the OS w/ Git, Java & Python3"
  sudo apt update -y
  sudo apt install -y wget git openjdk-11-jdk python3 python3-dev python3-pip net-tools ansible
  j_home=/usr/lib/jvm/java-11-openjdk
  arch=`arch`
  if [ "$arch" == "aarch64" ]; then
    j_home=$j_home-arm64
  fi

  sudo su - ubuntu

  echo "Install NIMOY"
  cd /home/ubuntu
  rm -rf test
  mkdir -p test/data
  cd test
  git clone https://github.com/OSCG-IO/tf-nimoy
  cd /home/ubuntu
  chown -R ubuntu:ubuntu test

  echo "Install ANT"
  cd /home/ubuntu
  ANT=apache-ant-1.9.16-bin
  rm -f $ANT.tar.gz
  wget http://mirror.olnevhost.net/pub/apache/ant/binaries/$ANT.tar.gz
  tar xf $ANT.tar.gz
  rm $ANT.tar.gz

  echo "### Configure .bashrc"
  echo "export JAVA_HOME=$j_home"                >> /home/ubuntu/.bashrc 
  echo 'export PATH=$PATH:$JAVA_HOME/bin'        >> /home/ubuntu/.bashrc
  echo 'export ANT_HOME=$HOME/apache-ant-1.9.16' >> /home/ubuntu/.bashrc
  echo 'export PATH=$ANT_HOME/bin:$PATH'         >> /home/ubuntu/.bashrc
  echo 'export RMT=$HOME/test/tf-nimoy/remote'   >> /home/ubuntu/.bashrc
  echo 'export PATH=$PATH:$HOME/oscg/pg14/bin'   >> /home/ubuntu/.bashrc

  echo "### rebooting to get new HOSTNAME"
  sudo reboot
EOF

}

