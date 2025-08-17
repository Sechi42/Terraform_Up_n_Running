# Versionado de terrraform

terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}


resource "aws_db_instance" "example" {
    identifier_prefix   = "terraform-up-and-running"
    allocated_storage   = 10
    instance_class      = "db.t3.micro"
    skip_final_snapshot = true
    

    # Permitir retención de replicas
    backup_retention_period = var.backup_retention_period

    # Si se especifica, esta db será una replica
    replicate_source_db = var.replicate_source_db


    # Solo declara estos parametros si replicate_source_db no se establecio
    engine              = var.replicate_source_db == null ? "mysql": null
    db_name             = var.replicate_source_db == null ? var.db_name : null
    username            = var.replicate_source_db == null ? var.db_username: null
    password            = var.replicate_source_db == null ? var.db_password : null
}

