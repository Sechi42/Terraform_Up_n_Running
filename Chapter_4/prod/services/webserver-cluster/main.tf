provider "aws" {
    region = "us-east-2"
}


module "web-cluster" {
    source = "../../../modules/services/webserver-cluster"

    cluster_name = "webservers-stage"
    db_remote_state_bucket = "terraform-up-and-running-state-evolu"
    db_remote_state_key = "prod/data-stores/mysql/terraform.statte"
}

