# Include VPC module
module "vpc" {
  source = "./modules/vpc"

  # Pass variables to the VPC module
  vpc_cidr_block           = "10.0.0.0/16"
  subnet_cidr_blocks       = ["10.0.1.0/24", "10.0.2.0/24"]  # Two private subnets
  availability_zones       = ["us-east-1a", "us-east-1b"]
  public_subnet_cidr       ="10.0.3.0/24"
  availability_zone_public    = "us-east-1c"
}


# Include IAM module
module "iam" {
  source = "./modules/iam"

  # Pass variables to the IAM module
  iam_username = "admin"
}
