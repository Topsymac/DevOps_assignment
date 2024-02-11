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
  # add to variables.tf
  availability_zone            = var.availability_zone_pub
  map_public_ip_on_launch      = true

  tags = {
    Name = "New_Public_Subnet"
  }
}

resource "aws_internet_gateway" "Igw" {
 vpc_id = aws_vpc.main.id
 
 tags = {
   Name = "Public-Igw"
   }
 }

 resource "aws_route_table" "Igw_route" {
  vpc_id = aws_vpc.main.id


  tags = {
    Name = "Public_Igw"
  }
 }

resource "aws_route" "Igw" {
  route_table_id         = aws_route_table.Igw_route.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.Igw.id 
}

resource "aws_route_table_association" "Public_asso" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.Igw_route.id
  
}

###################################################





# Create local route in route table
# resource "aws_route" "local" {
#   route_table_id         = aws_route_table.Local.id
#   destination_cidr_block = aws_vpc.main.cidr_block
#   gateway_id             = "local" 
# }

# resource "aws_route_table_association" "Local_Subnet" {
#   subnet_id      = aws_subnet.private[count.index].id
#   route_table_id = aws_route_table.Local.id
  
# }


# resource "aws_eip" "nat" {
#   vpc = true
# }








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