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
  # remove this line and add the variables like you did in subnets, this way user just needs to change the outer code variables instead of going inside the variables under the vpc module
  # add providers.tf and add variables in variables.tf for outer main.tf
 # Adjust with your desired AZs
}
variable "public_subnet_cidr" {
  description  = "Public subnet"
  type         = string
}

variable "availability_zone_pub"{
  description   = "Public subnet availability zone"
  type          = string
}


# variable "vpc_cidr_block"  {
#     default = "10.0.0.0/16"
# }  a
# variable "region" {
#     default = "us-east-1"
# }
# variable "public_subnet_cidr_block" {
#     default = "10.0.1.0/24"
# }
# variable "private_subnet_cidr_block" {
#   default = "10.0.2.0/24"
# }
# variable "webserver_instance_type" {
#   default = "t2.micro"
# }
# variable "database_instance_type" {
#   default  = "t2.micro"
# }
# variable "public_subnet_cidrs" {
#  type        = list(string)
#  description = "Public Subnet CIDR values"
#  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
# }
 
# variable "private_subnet_cidrs" {
#  type        = list(string)
#  description = "Private Subnet CIDR values"
#  default     = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
# }
# variable "azs" {
#  type        = list(string)
#  description = "Availability Zones"
#  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
# }
