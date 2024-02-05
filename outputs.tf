output "vpc_id" {
  description = "ID of the created VPC"
  value       = module.vpc.vpc_id
}

output "subnet_ids" {
  description = "IDs of the created subnets"
  value       = module.vpc.subnet_ids
}

output "iam_user_arn" {
  description = "ARN of the created IAM user"
  value       = module.iam.iam_user_arn
}