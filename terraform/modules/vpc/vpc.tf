locals {
  name   = "eks-lab"
  domain = var.domain
  region = var.region

  cluster_name = var.cluster_name

  tags = {
    Environment = "dev"
    Project     = "EKS Project"
    Owner       = "Ridwan"
  }
}

resource "aws_vpc" "eks" {
  cidr_block = var.base_cidr
  region = var.region
}

resource "aws_subnet" "set" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"

  tags = { 
      local.tags
  }
}


# create subnets

resource "aws_subnet" "set" {
  count             = var.subnet_count
  vpc_id           = aws_vpc.main.id
  cidr_block       = cidrsubnet(var.base_cidr, 2, count.index)
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name = "Subnet-${count.index}"
  }
}

# Create internet gateway

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main-igw"
  }
}