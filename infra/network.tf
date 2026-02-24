resource "aws_vpc" "p2" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  instance_tenancy     = "default"
  tags = { Name = var.vpc_name }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.p2.id
  tags   = { Name = "${var.vpc_name}-igw" }
}

# Public subnets
resource "aws_subnet" "public_a" {
  vpc_id                  = aws_vpc.p2.id
  cidr_block              = "10.0.0.0/24"
  availability_zone       = var.az_a
  map_public_ip_on_launch = true
  tags = { Name = "public-a" }
}

resource "aws_subnet" "public_b" {
  vpc_id                  = aws_vpc.p2.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = var.az_b
  map_public_ip_on_launch = true
  tags = { Name = "public-b" }
}

# App private subnets
resource "aws_subnet" "app_a" {
  vpc_id            = aws_vpc.p2.id
  cidr_block        = "10.0.10.0/24"
  availability_zone = var.az_a
  tags = { Name = "app-a-private" }
}

resource "aws_subnet" "app_b" {
  vpc_id            = aws_vpc.p2.id
  cidr_block        = "10.0.11.0/24"
  availability_zone = var.az_b
  tags = { Name = "app-b-private" }
}

# DB private subnets
resource "aws_subnet" "db_a" {
  vpc_id            = aws_vpc.p2.id
  cidr_block        = "10.0.20.0/24"
  availability_zone = var.az_a
  tags = { Name = "db-a" }
}

resource "aws_subnet" "db_b" {
  vpc_id            = aws_vpc.p2.id
  cidr_block        = "10.0.21.0/24"
  availability_zone = var.az_b
  tags = { Name = "db-b" }
}

# Route tables
resource "aws_route_table" "rt_public" {
  vpc_id = aws_vpc.p2.id
  tags   = { Name = "rt-public" }
}

resource "aws_route" "public_internet" {
  route_table_id         = aws_route_table.rt_public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table" "rt_app_private" {
  vpc_id = aws_vpc.p2.id
  tags   = { Name = "rt-app-private" }
}

resource "aws_route_table" "rt_db_private" {
  vpc_id = aws_vpc.p2.id
  tags   = { Name = "rt-db-private" }
}

# Associations
resource "aws_route_table_association" "public_a" {
  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_route_table.rt_public.id
}
resource "aws_route_table_association" "public_b" {
  subnet_id      = aws_subnet.public_b.id
  route_table_id = aws_route_table.rt_public.id
}
resource "aws_route_table_association" "app_a" {
  subnet_id      = aws_subnet.app_a.id
  route_table_id = aws_route_table.rt_app_private.id
}
resource "aws_route_table_association" "app_b" {
  subnet_id      = aws_subnet.app_b.id
  route_table_id = aws_route_table.rt_app_private.id
}
resource "aws_route_table_association" "db_a" {
  subnet_id      = aws_subnet.db_a.id
  route_table_id = aws_route_table.rt_db_private.id
}
resource "aws_route_table_association" "db_b" {
  subnet_id      = aws_subnet.db_b.id
  route_table_id = aws_route_table.rt_db_private.id
}
