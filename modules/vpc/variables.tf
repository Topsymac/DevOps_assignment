# Declare variables
variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
}

variable "subnet_cidr_blocks" {
  description = "CIDR blocks for the subnets"
  type        = list(string)
}

variable "availability_zones" {
  description = "List of availability zones for subnets"
  type        = list(string)
  
}

variable "public_subnet_cidr" {
  description  = "Public subnet"
  type         = string
}

variable "availability_zone_public"{
  description   = "Public subnet availability zone"
  type          = string
}


