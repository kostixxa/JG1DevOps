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
  region  = "us-east-1"
}

resource "aws_instance" "ansible_master" {
  ami           = "ami-007855ac798b5175e"
  instance_type = "t2.micro"
  key_name   = "ansible-key-pair2"

  user_data = <<-EOF
             #!/bin/bash
             apt-get update
             apt-get install -y python3 python3-pip
             pip3 install ansible
             EOF

  tags = {
    Name = "ansible-server-1"
    Owner = "PavelsGrr"
  }
}

resource "aws_instance" "ansible_master_2" {
  ami           = "ami-007855ac798b5175e"
  instance_type = "t2.micro"
  key_name   = "ansible-key-pair2"

  user_data = <<-EOF
             #!/bin/bash
             useradd ansible 
             yum update > /home/ansible/update.log
             yum install epel-release > /home/ansible/update.log
             yum install ansible > /home/ansible/update.log
             EOF

  tags = {
    Name = "ansible-server-2"
    Owner = "PavelsGrr"
  }
}



resource "aws_instance" "app_server" {
  count         = 2  # number of instances to create
  ami           = "ami-007855ac798b5175e"
  instance_type = "t2.micro"
  
  

  key_name   = "ansible-key-pair2"

  tags = {
    Name = "app-server-${count.index+1}"
    Owner = "PavelsGrr"
  }
}

resource "aws_instance" "db_server" {
  count         = 2  # number of instances to create
  ami           = "ami-007855ac798b5175e"
  instance_type = "t2.micro"

  key_name   = "ansible-key-pair2"

  tags = {
    Name = "db-server-${count.index+1}"
    Owner = "PavelsGrr"
  }
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Replace with your IP address in CIDR notation for better security
  }
}


output "server_info" {
  value = {
    app = {
      for instance in aws_instance.app_server :
      instance.tags["Name"] => instance.public_ip
    },
    db = {
      for instance in aws_instance.db_server :
      instance.tags["Name"] => instance.public_ip
    }
  }
}
