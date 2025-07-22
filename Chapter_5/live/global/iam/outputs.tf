output "all_arns" {
    value = aws_iam_user.example[*].arn
    description = "The ARN for all the iam user created"
}
