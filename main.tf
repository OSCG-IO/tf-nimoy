
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

data "http" "myip" {
  url = "http://ipv4.icanhazip.com"
}

locals {
  driver = format("%s%s", "driver", var.nn)
  node   = format("%s%s", "node",   var.nn)
  sg     = format("%s%s%s", var.cluster_nm, "-sg",  var.nn)
  sub    = format("%s%s%s", var.cluster_nm, "-sn",   var.nn)
  cdr    = format("%s%s%s", "172.31.",  80+(tonumber(substr(var.nn,0,1)) * 16), ".0/20")
  pgv    = format("%s%s", "pg", var.pg_v)
}

provider "aws" {
  region  = var.rgn
}

resource "aws_default_vpc" "default" {
}

resource "aws_subnet" "sub" {
  count = 0
  vpc_id = aws_default_vpc.default.id
  availability_zone = var.az 
  cidr_block = local.cdr
  map_public_ip_on_launch = true
  tags = {
    Name = local.sub
  }
}
  
resource "aws_security_group" "sg" {
  name = local.sg
  vpc_id = aws_default_vpc.default.id
  tags = {
    Name = local.sg
  }
}

resource "aws_security_group_rule" "egress" {
  type              = "egress"
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 0
  security_group_id = aws_security_group.sg.id
}

resource "aws_security_group_rule" "local-ssh" {
  type              = "ingress"
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["${chomp(data.http.myip.body)}/32"]
  from_port         = 22
  security_group_id = aws_security_group.sg.id
}

resource "aws_security_group_rule" "local-prompgexp" {
  type              = "ingress"
  to_port           = 9187
  protocol          = "tcp"
  cidr_blocks       = ["${chomp(data.http.myip.body)}/32"]
  from_port         = 9187
  security_group_id = aws_security_group.sg.id
}

resource "aws_security_group_rule" "net-pg" {
  type              = "ingress"
  to_port           = 5432
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 5432
  security_group_id = aws_security_group.sg.id
}

resource "aws_security_group_rule" "net-ssh" {
  type              = "ingress"
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 22
  security_group_id = aws_security_group.sg.id
}

resource "aws_instance"  "node" {
  ami           = var.image
  instance_type = var.type
  availability_zone = var.az
  key_name = var.key
  vpc_security_group_ids = [aws_security_group.sg.id]
  tags = {
    Name = local.node
  }
   user_data = <<EOF
#! /bin/bash
  echo "### Set HOSTNAME & Disable SELINUX"
  echo "${local.node}" > /etc/hostname
  sudo sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config

  echo "### Update the OS"
  sudo yum update -y
  sudo yum install -y wget curl net-tools
  sudo yum install -y epel-release
  sudo yum install -y python39

  echo "Setup /db"
  sudo mkdir /db
  sudo chown centos:centos /db

  echo "### Configure .bashrc"
  echo 'export PATH=$PATH:/db/oscg/${local.pgv}/bin'     >> /home/centos/.bashrc

  echo "### rebooting"
  sudo reboot
EOF

}


resource "aws_instance" "driver" {
  ami           = var.image
  instance_type = var.type
  availability_zone = var.az
  key_name = var.key
  vpc_security_group_ids = [aws_security_group.sg.id]
  tags = {
    Name = local.driver
  }
 user_data = <<EOF
#! /bin/bash
  echo "### Set HOSTNAME & Disable SELINUX"
  echo "${local.driver}" > /etc/hostname
  sudo sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config

  echo "### Update the OS w/ Git, Java, Python39 & Ansible"
  sudo yum update -y
  sudo yum install -y wget curl net-tools git
  sudo yum install -y java-11-openjdk-devel

  sudo yum install -y epel-release
  sudo yum install -y python39
  sudo pip3 install ansible

  j_home=/etc/alternatives/jre_11_openjdk

  sudo su - centos

  echo "Install NIMOY"
  cd /home/centos
  rm -rf test
  mkdir -p test/data
  cd test
  git clone https://github.com/OSCG-IO/tf-nimoy
  git checkout dev
  cd /home/centos
  chown -R centos:centos test

  echo "Install ANT"
  cd /home/centos
  ANT=apache-ant-1.9.16-bin
  rm -f $ANT.tar.gz
  wget http://mirror.olnevhost.net/pub/apache/ant/binaries/$ANT.tar.gz
  tar xf $ANT.tar.gz
  rm $ANT.tar.gz

  echo "### Configure .bashrc"
  echo "export JAVA_HOME=$j_home"                >> /home/centos/.bashrc 
  echo 'export PATH=$PATH:$JAVA_HOME/bin'        >> /home/centos/.bashrc
  echo 'export ANT_HOME=$HOME/apache-ant-1.9.16' >> /home/centos/.bashrc
  echo 'export PATH=$ANT_HOME/bin:$PATH'         >> /home/centos/.bashrc
  echo 'export RMT=$HOME/test/tf-nimoy/remote'   >> /home/centos/.bashrc
  echo 'export PATH=$PATH:$HOME/oscg/${local.pgv}/bin'   >> /home/centos/.bashrc

  echo "### rebooting"
  sudo reboot
EOF

}

