output "all_users" {
    value = aws_iam_user.example
    description = "The ARN for all the iam user created"
}


output "all_arns" {
    value = values(aws_iam_user.example)[*].arn
}