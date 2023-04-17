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

resource "aws_instance" "ansible_master_2" {
  ami           = "ami-007855ac798b5175e"
  instance_type = "t2.micro"
  key_name   = "pavelsJG-amazon-key"

  user_data = <<-EOF
             #!/bin/bash
             useradd ansible 
             yum update > /home/ansible/update.log
             yum install epel-release > /home/ansible/update.log
             yum install ansible > /home/ansible/update.log
             EOF

vpc_security_group_ids = [ 
  aws_security_group.PavelsM_allow_ssh.id, 
  ] 

  tags = {
    Name = "PavelsM-ansible-server-2"
    Owner = "PavelsM"
  }
}

resource "aws_instance" "app_server" {
  count         = 2  # number of instances to create
  ami           = "ami-007855ac798b5175e"
  instance_type = "t2.micro"
  
  

  key_name   = "pavelsJG-amazon-key"

  tags = {
    Name = "PavelsM-app-server-${count.index+1}"
    Owner = "PavelsM"
  }
}

resource "aws_instance" "db_server" {
  count         = 2  # number of instances to create
  ami           = "ami-007855ac798b5175e"
  instance_type = "t2.micro"

  key_name   = "pavelsJG-amazon-key"

vpc_security_group_ids = [
  aws_security_group.PavelsM_allow_ssh.id,
  ]

  tags = {
    Name = "PavelsM-db-server-${count.index+1}"
    Owner = "PavelsM"
  }
}

resource "aws_security_group" "PavelsM_allow_ssh" {
  name        = "PavelsM_allow_ssh"
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
