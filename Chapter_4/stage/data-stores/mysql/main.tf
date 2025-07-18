provider "aws" {
    region = "us-east-2"
}

module "web-cluster" {
    source = "../../../modules/services/webserver-cluster"

    cluster_name = "webservers-stage"
    db_remote_state_bucket = "terraform-up-and-running-stage"
    db_remote_state_key = "stage/data-stores/mysql/terraform.tfstate"
}

