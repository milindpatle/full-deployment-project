resource "aws_vpc" "vpc1" {
  cidr_block           = var.vpc_cidr_1
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "${var.project}-tooling-vpc"
  }
}

resource "aws_internet_gateway" "vpc1_igw" {
  vpc_id = aws_vpc.vpc1.id
  tags = {
    Name = "${var.project}-vpc1-igw"
  }
}

resource "aws_subnet" "vpc1_pub" {
  count = length(var.public_azs)
  vpc_id                  = aws_vpc.vpc1.id
  cidr_block              = cidrsubnet(aws_vpc.vpc1.cidr_block, 8, count.index)
  map_public_ip_on_launch = true
  availability_zone       = var.public_azs[count.index]
  tags = {
    Name = "${var.project}-vpc1-public-${count.index}"
  }
}

resource "aws_route_table" "vpc1_public_rt" {
  vpc_id = aws_vpc.vpc1.id
  tags = {
    Name = "${var.project}-vpc1-public-rt"
  }
}

resource "aws_route" "vpc1_public_route" {
  route_table_id         = aws_route_table.vpc1_public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.vpc1_igw.id
}

resource "aws_route_table_association" "vpc1_assoc" {
  count = length(aws_subnet.vpc1_pub)
  subnet_id      = aws_subnet.vpc1_pub[count.index].id
  route_table_id = aws_route_table.vpc1_public_rt.id
}


resource "aws_vpc" "vpc2" {
  cidr_block           = var.vpc_cidr_2
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "${var.project}-apps-vpc"
  }
}

resource "aws_internet_gateway" "vpc2_igw" {
  vpc_id = aws_vpc.vpc2.id
  tags = {
    Name = "${var.project}-vpc2-igw"
  }
}

resource "aws_subnet" "vpc2_pub" {
  count = length(var.public_azs)
  vpc_id                  = aws_vpc.vpc2.id
  cidr_block              = cidrsubnet(aws_vpc.vpc2.cidr_block, 8, count.index + 20)
  map_public_ip_on_launch = true
  availability_zone       = var.public_azs[count.index]
  tags = {
    Name = "${var.project}-vpc2-public-${count.index}"
  }
}

resource "aws_route_table" "vpc2_public_rt" {
  vpc_id = aws_vpc.vpc2.id
  tags = {
    Name = "${var.project}-vpc2-public-rt"
  }
}

resource "aws_route" "vpc2_public_route" {
  route_table_id         = aws_route_table.vpc2_public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.vpc2_igw.id
}

resource "aws_route_table_association" "vpc2_pub_assoc" {
  count = length(aws_subnet.vpc2_pub)
  subnet_id      = aws_subnet.vpc2_pub[count.index].id
  route_table_id = aws_route_table.vpc2_public_rt.id
}


resource "aws_eip" "vpc2_nat_eip" {
  domain = "vpc"
}

resource "aws_nat_gateway" "vpc2_nat" {
  allocation_id = aws_eip.vpc2_nat_eip.id
  subnet_id     = aws_subnet.vpc2_pub[0].id
  tags = {
    Name = "${var.project}-vpc2-nat"
  }
}

resource "aws_subnet" "vpc2_priv" {
  count = length(var.public_azs)
  vpc_id            = aws_vpc.vpc2.id
  cidr_block        = cidrsubnet(aws_vpc.vpc2.cidr_block, 8, count.index + 10)
  availability_zone = var.public_azs[count.index]
  tags = {
    Name = "${var.project}-vpc2-private-${count.index}"
  }
}

resource "aws_route_table" "vpc2_private_rt" {
  vpc_id = aws_vpc.vpc2.id
  tags = {
    Name = "${var.project}-vpc2-private-rt"
  }
}

resource "aws_route" "vpc2_private_route" {
  route_table_id         = aws_route_table.vpc2_private_rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.vpc2_nat.id
}

resource "aws_route_table_association" "vpc2_priv_assoc" {
  count = length(aws_subnet.vpc2_priv)
  subnet_id      = aws_subnet.vpc2_priv[count.index].id
  route_table_id = aws_route_table.vpc2_private_rt.id
}


resource "aws_vpc_peering_connection" "peer" {
  vpc_id      = aws_vpc.vpc1.id
  peer_vpc_id = aws_vpc.vpc2.id
  auto_accept = true
  tags = {
    Name = "${var.project}-peering"
  }
}

resource "aws_security_group" "jenkins_sg" {
  name   = "${var.project}-jenkins-sg"
  vpc_id = aws_vpc.vpc1.id

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project}-jenkins-sg"
  }
}
