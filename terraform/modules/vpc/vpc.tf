locals {
  zone1 = "eu-west-2a"
  zone2 = "eu-west-2b"
  eks_name = "cluster-lab"
}



# create vpc

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  region = var.region
  tags = {
    Name = "main"
  }
}

# create subnets

resource "aws_subnet" "private_zone1" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.0.0/19"
  availability_zone = local.zone1

  tags ={
    name = "private-$(local.zone1)"
    "kubernetes.io/role/internal-elb" = "1"
    "kubernetes.io/cluster/${local.eks_name}" = "owned"
  }
}

resource "aws_subnet" "private_zone2" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.32.0/19"
  availability_zone = local.zone2

  tags ={
    name = "private-$(local.zone2)"
    "kubernetes.io/role/internal-elb" = "1"
    "kubernetes.io/cluster/${local.eks_name}" = "owned"
  }
}

# create public subnets

resource "aws_subnet" "public_zone1" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.32.0/19"
  availability_zone = local.zone1
  map_public_ip_on_launch = true

  tags ={
    "name" = "public-{local.zone1}"
    "kubernetes.io/role/elb" = "1"
    "kubernetes.io/cluster/${local.eks_name}" = "owned"
  }

  
}

resource "aws_subnet" "public_zone2" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.64.0/19"
  availability_zone = local.zone2
  map_public_ip_on_launch = true

  tags ={
    "name" = "public-${local.zone2}"
    "kubernetes.io/role/elb" = "1"
    "kubernetes.io/cluster/${local.eks_name}" = "owned"
  }
}

# Create internet gateway

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main-igw"
  }
}

# Create NAT gateway in public subnets

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public_zone1.id

  tags = {
    Name = "NAT-gw-az1"
  }

  depends_on = [aws_internet_gateway.main]
  }

resource "aws_eip" "nat" {
  domain   = "vpc"
}