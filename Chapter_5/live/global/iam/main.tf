provider "aws" {
    region = "us-east-2"
}

resource "aws_iam_user" "example" {
    for_each = toset(var.user_names)
    name     = each.value   
}

#Read only access
resource "aws_iam_policy" "cloudwatch_read_only" {
    name = "cloudwatch-read-only"
    policy = data.aws_iam_policy_document.cloudwatch_read_only.json 
}

resource "aws_iam_policy_document" "cloudwatch_read_only" {
    statement {
        effect = "Allow"
        action = [
            "cloudwatch:Describe*",
            "cloudwatch:Get*",
            "cloudwatch:List*"
        ]
        resources = ["*"]
    }
}

# Cloudwatch acceso completo
resource "aws_iam_policy" "cloudwatch_full_acces" {
    name = "cloudwatch-read-only"
    policy = data.aws_iam_policy_document.cloudwatch_full_acces.json 
}

resource "aws_iam_policy_document" "cloudwatch_full_acces" {
    statement {
        effect = "Allow"
        action = [
            "cloudwatch:*"
        ]
        resources = ["*"]
    }
}

resource "aws_iam_user_policy_attachment" "neo_cloudwatch_full_acces" {
    count = var.give_neo_cloudwatch_full_access ? 1 : 0

    user = aws_iam_user.example[0].name
    policy_arn = aws_iam_policy.cloudwatch_full_acces.arn
}

resource "aws_iam_user_policy_attachment" "neo_cloudwatch_read_only" {
    count = var.give_neo_cloudwatch_full_access ? 0 : 1

    user = aws_iam_user.example[0].name
    policy_arn = aws_iam_policy.cloudwatch_read_only.arn
}