 provider "aws" {
  region = "ap-south-1"
}
resource "aws_iam_user" "admin" {
  name = "terraform-admin"
}
resource "aws_iam_user_policy_attachment" "administrator" {
  user       = aws_iam_user.admin.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}
resource "aws_iam_user_policy_attachment" "ec2" {
  user       = aws_iam_user.admin.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}
output "iam_user_name" {
  value = aws_iam_user.admin.name
}
output "iam_user_arn" {
  value = aws_iam_user.admin.arn
}
