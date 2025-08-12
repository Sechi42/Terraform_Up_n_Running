# Declarando 2 regiones para su uso

provider "aws" {
  region = "us-east-2"
  alias  = "primary"
}

provider "aws" {
  region = "us-west-1"
  alias  = "replica"
}

terraform {
    backend "s3" {
        bucket         = "terraform-up-and-running-state-evolu"
        key            = "prod/data-stores/mysql/terraform.statte"
        region         = "us-east-2"
        dynamodb_table = "terraform-up-and-running-locks"
        encrypt        = true
    }
}

module "mysql_primary" {
    source = "../../../../modules/data-stores/mysql"

    providers = {
      aws = aws.primary
    }
    
    db_name = "prod_db"
    db_username            = var.db_username
    db_password            = var.db_password

    # Debe ser permitido para que sea replicable
    backup_retention_period = 1
}

module "mysql_replica" {
    source = "../../../../modules/data-stores/mysql"
    
    providers = {
      aws = aws.replica
    }
    
    # Haz una replica de la primera db
    replicate_source_db = module.mysql_primary.arn
}


