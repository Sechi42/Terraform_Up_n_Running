provider "aws" {
    region = "us-east-2"
}

# Desnecriptador de secretos

data "aws_kms_secrets" "creds" {
    secret {
      name = "db"
      payload = file("c:/Users/evolu/Desktop/Master/terraform/Chapter_6/Exploración/mysql-kms/db-creds.yml.encrypted")
    }
}

locals {
  db_creds = yamldecode(data.aws_kms_secrets.creds.plaintext["db"])
}

terraform {
    backend "s3" {
        bucket         = "terraform-up-and-running-state-evolu"
        key            = "stage/data-stores/mysql/terraform.tfstate"
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

    #Pasar los secretos kms
    username            = local.db_creds.username
    password            = local.db_creds.password
  
}

