# Create IAM user
resource "aws_iam_user" "main" {
  name = var.iam_username

  tags = {
    Name = "AdminUser"
  }
}
