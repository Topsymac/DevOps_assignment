output "iam_user_arn" {
  description = "ARN of the created IAM user"
  value       = aws_iam_user.main.arn
}

