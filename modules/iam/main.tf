# Create IAM user
resource "aws_iam_user" "main" {
  name = var.iam_username

  tags = {
    Name = "AdminUser"
  }
}

# Attach IAM policy to user
resource "aws_iam_user_policy_attachment" "admin_policy_attachment" {
  user       = aws_iam_user.main.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}