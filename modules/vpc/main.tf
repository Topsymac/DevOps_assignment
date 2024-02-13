resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr_block

  tags = {
    Name = "MainVPC"
  }
}

# Create Private subnets
resource "aws_subnet" "private" {
  count             = length(var.subnet_cidr_blocks)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.subnet_cidr_blocks[count.index]
  availability_zone = element(var.availability_zones, count.index)  # Change to your desired AZ
  
  tags = {
    Name = "PrivateSubnet-${count.index}"
  }
}

# Create route table

resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "MainRouteTable"
  }

}

# Associate subnets with route table
resource "aws_route_table_association" "private" {
  count          = length(aws_subnet.private)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.main.id
}

# Create NAT gateway
resource "aws_nat_gateway" "main" {
  
  connectivity_type = "private"
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

#Create public subnet Newly Moved

resource "aws_subnet" "public" {
  vpc_id                       = aws_vpc.main.id
  cidr_block                   = var.public_subnet_cidr 
  availability_zone            = var.availability_zone_public
  map_public_ip_on_launch      = true

  tags = {
    Name = "Public_Subnet"
  }
}

resource "aws_internet_gateway" "Igw" {
 vpc_id = aws_vpc.main.id
 
 tags = {
   Name = "Internet-Gateway"
   }
 }

 resource "aws_route_table" "Igw_route" {
  vpc_id = aws_vpc.main.id


  tags = {
    Name = "RT-Internet_Gateway"
  }
 }

resource "aws_route" "Igw" {
  route_table_id         = aws_route_table.Igw_route.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.Igw.id 
}

resource "aws_route_table_association" "Public_Subnet_association" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.Igw_route.id
  
}


