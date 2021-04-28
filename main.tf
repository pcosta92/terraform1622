    terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 2.0"
    }
  }
}

provider "aws" {
  region     = "us-west-2"
  access_key = ""
  secret_key = ""
}

  resource "aws_security_group" "sg_mysql" {
  name   = "sg_mysql"
  ingress {
    description = "mysql"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "ssh"
    from_port   = 22
    to_port     = 22
    protocol    = "all"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.myinstance.id
  allocation_id = aws_eip.teste.id
}

resource "aws_instance" "myinstance" {
  ami           = "ami-0518bb0e75d3619ca"
  instance_type = "t2.micro"
   key_name = "OI-HML-WEB"
    security_groups = ["sg_mysql"]
  tags = {
    Name = "Teste"
    
    }
}

resource "aws_eip" "teste" {
  vpc = true
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}
resource "null_resource" "apt" {
    triggers = {
    order = "myinstance"
    }
    provisioner "remote-exec" {
      connection {
        type = "ssh"
        user = "ec2-user"
        private_key = file("C:/Users/pablo.costa/desktop/mysql-vagrant/OI-HML-WEB.pem")
        host = aws_instance.myinstance.public_ip
}
    inline = [
      "cd /tmp/",
      
      "sudo wget https://teste-terraform1622.s3-us-west-2.amazonaws.com/install_mysql.sh",
      
      "sh /tmp/install_mysql.sh"
    ]       
    }
}
