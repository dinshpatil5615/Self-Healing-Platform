data "aws_availability_zones" "available" {}

resource "aws_vpc" "main" {
  cidr_block = var.cidr
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "self-healing-igw"
  }
}

# Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public-route-table"
  }
}

# Associate Route Table with Public Subnets
resource "aws_route_table_association" "public_subnet_assoc" {
  count          = length(aws_subnet.Public)
  subnet_id      = aws_subnet.Public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_subnet" "Public" {
  vpc_id = aws_vpc.main.id
  count = 2
  cidr_block = cidrsubnet(var.cidr, 8, count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true
}

resource "aws_subnet" "Private" {
  vpc_id = aws_vpc.main.id
  count = 2
  cidr_block = cidrsubnet(var.cidr, 8, count.index + 10)
  availability_zone = data.aws_availability_zones.available.names[count.index]
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id = aws_subnet.Public[0].id
}

resource "aws_eip" "nat" {
  domain = "vpc"
}

