provider "aws" {
    region = "us-east-2"
}

terraform {
    backend "s3" {
        bucket         = "terraform-up-and-running-state-evolu"
        key            = "stage/data-stores/mysql/terraform.statte"
        region         = "us-east-2"
        dynamodb_table = "terraform-up-and-running-locks"
        encrypt        = true
    }
}


resource "aws_db_instance" "example" {
    identifier_prefix   = "terraform-up-and-running"
    engine              = "mysql"
    allocated_storage   = 10
    instance_class      = "db.t3.micro"
    skip_final_snapshot = true
    db_name             = "example_database"

    # How should we set he username and password
    username            = var.db_username
    password            = var.db_password
  
}

output "address" {
    value       = aws_db_instance.example.address
    description = "Connect to the database at this endpoint"
}

output "port" {
    value       = aws_db_instance.example.port
    description = "The port the database is listening on"
}
