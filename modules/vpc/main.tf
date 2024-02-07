# Create VPC
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr_block

  tags = {
    Name = "MainVPC"
  }
}

# Create subnets
resource "aws_subnet" "private" {
  count             = length(var.subnet_cidr_blocks)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.subnet_cidr_blocks[count.index]
  availability_zone = element(var.availability_zones, count.index)  # Change to your desired AZ
  
  tags = {
    Name = "PrivateSubnet-${count.index}"
  }
}

# Create internet gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "InternetGateway"
  }
}

# Create route table
resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "MainRouteTable"
  }
}

# Create local route in route table
# resource "aws_route" "local" {
#   route_table_id         = aws_route_table.main.id
#   destination_cidr_block = aws_vpc.main.cidr_block
#   gateway_id             = "local"
# }
# Declare Elastic IP resource
resource "aws_eip" "nat" {
  # Specify the appropriate attributes for the Elastic IP resource
  # For example:
  vpc = true
}


# Create NAT gateway
resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id  # Reference the ID of the Elastic IP resource
  subnet_id     = aws_subnet.private[0].id  # Change to your desired private subnet ID

  tags = {
    Name = "NATGateway"
  }
}

# Create route for NAT gateway in route table
resource "aws_route" "nat_gateway" {
  route_table_id         = aws_route_table.main.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.main.id
}

# Associate subnets with route table
resource "aws_route_table_association" "private" {
  count          = length(var.subnet_cidr_blocks)
  subnet_id      = aws_subnet.private[0].id
  route_table_id = aws_route_table.main.id
}


# resource "aws_vpc" "main" {
#  cidr_block = "10.0.0.0/16"
 
#  tags = {
#    Name = "Project VPC"
#  }
# }
# resource "aws_subnet" "public_subnets" {
#  count             = length(var.public_subnet_cidrs)
#  vpc_id            = aws_vpc.main.id
#  cidr_block        = element(var.public_subnet_cidrs, count.index)
#  availability_zone = element(var.azs, count.index)
 
#  tags = {
#    Name = "Public Subnet ${count.index + 1}"
#  }
# }
 
# resource "aws_subnet" "private_subnets" {
#  count             = length(var.private_subnet_cidrs)
#  vpc_id            = aws_vpc.main.id
#  cidr_block        = element(var.private_subnet_cidrs, count.index)
#  availability_zone = element(var.azs, count.index)
 
#  tags = {
#    Name = "Private Subnet ${count.index + 1}"
#  }
# }
# resource "aws_internet_gateway" "gw" {
#  vpc_id = aws_vpc.main.id
 
#  tags = {
#    Name = "Project VPC IG"
#  }
# }
# resource "aws_route_table" "second_rt" {
#  vpc_id = aws_vpc.main.id
 
#  route {
#    cidr_block = "0.0.0.0/0"
#    gateway_id = aws_internet_gateway.gw.id
#  }
 
#  tags = {
#    Name = "2nd Route Table"
#  }
# }
# resource "aws_route_table_association" "public_subnet_asso" {
#  count = length(var.public_subnet_cidrs)
#  subnet_id      = element(aws_subnet.public_subnets[*].id, count.index)
#  route_table_id = aws_route_table.second_rt.id
# }