provider "aws" {
    #profile = "sgti-st-sb003"
    profile = "default"
    region  = "eu-west-1"
}
 
# create the VPC
resource "aws_vpc" "akashni_vpc" {
    cidr_block  =   "10.10.30.0/24" #Jon-lee 10.10.20.0/24 Akashni 10.10.30.0/24 Karabo 10.10.40.0/24
    enable_dns_support   = true
    enable_dns_hostnames = true
    tags = {
        Name = "akashni_vpc"
        accountName = var.accountName
        applicationName = var.applicationName
        costCenter = var.costCenter
        costCenterOwner = var.costCenterOwner
        environment = var.environment
    }
}
 
# create the Subnet
resource "aws_subnet" "akashni_subnet" {
    vpc_id      =  aws_vpc.akashni_vpc.id 
    cidr_block  =  "10.10.30.0/25"
    tags = {
        Name = "akashni_subnet"
        accountName = var.accountName
        applicationName = var.applicationName
        costCenter = var.costCenter
        costCenterOwner = var.costCenterOwner
        environment = var.environment
    }
}

# create second Subnet
resource "aws_subnet" "akashni2_subnet" {
    vpc_id      =  aws_vpc.akashni_vpc.id 
    cidr_block  =  "10.10.30.128/25"
    tags = {
        Name = "akashni2_subnet"
        accountName = var.accountName
        applicationName = var.applicationName
        costCenter = var.costCenter
        costCenterOwner = var.costCenterOwner
        environment = var.environment
    }
} 
 
# create EC2 instance
# ami-063d4ab14480ac177 and t2.micro
resource "aws_instance" "akashni_instance" {
    ami           = "ami-063d4ab14480ac177" 
    instance_type = "t2.micro"
    vpc_security_group_ids = [aws_security_group.akashni_security.id]
    subnet_id = aws_subnet.akashni_subnet.id

    tags = {
        Name = "akashni_instance"
        accountName = var.accountName
        applicationName = var.applicationName
        costCenter = var.costCenter
        costCenterOwner = var.costCenterOwner
        environment = var.environment
    }
}
 
# create second EC2 instance
# ami-063d4ab14480ac177 and t2.micro
resource "aws_instance" "akashni2_instance" {
    ami           = "ami-063d4ab14480ac177" 
    instance_type = "t2.micro"
    vpc_security_group_ids = [aws_security_group.akashni_security.id]
    subnet_id = aws_subnet.akashni2_subnet.id

    tags = {
        Name = "akashni2_instance"
        accountName = var.accountName
        applicationName = var.applicationName
        costCenter = var.costCenter
        costCenterOwner = var.costCenterOwner
        environment = var.environment
    }
}

 
# create security group for instances (allow https port 443 inbound only)
resource "aws_security_group" "akashni_security" {
  name        = "akashni_security"
  description = "Allow https port 443 inbound only"
  vpc_id      = aws_vpc.akashni_vpc.id 

  ingress {
    description      = "TLS from VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = [aws_vpc.akashni_vpc.cidr_block]
  }

  tags = {
        Name = "akashni_security"
        accountName = var.accountName
        applicationName = var.applicationName
        costCenter = var.costCenter
        costCenterOwner = var.costCenterOwner
        environment = var.environment
  }
}