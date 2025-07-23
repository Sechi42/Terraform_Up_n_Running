provider "aws" {
    region = "us-east-2"
}

resource "aws_iam_user" "example" {
    for_each = toset(var.user_names)
    name     = each.value   
}

resource "aws_instance" "example" {
    for_each = toset(var.instance_names)
    ami      = "ami-0fb653ca2d3203ac1"
    instance_type = "t2.micro"
    tags = {
        Name = each.value
    }
}