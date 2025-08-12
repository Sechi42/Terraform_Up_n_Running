
output "primary_address" {
    value       = module.mysql_primary.address
    description = "Connect to the database at this endpoint"
}

# Puerto en el que escucha la base de datos
output "primary_port" {
    value       = module.mysql_primary.port
    description = "The port the database is listening on"
}

output "primary_arn" {
    value       = module.mysql_primary.arn
    description = "ARN de la db primaria"
  
}


output "replica_address" {
    value       = module.mysql_replica.address
    description = "Connect to the replica database at this endpoint"
}

# Puerto en el que escucha la base de datos
output "replica_port" {
    value       = module.mysql_replica.port
    description = "The port the replica database is listening on"
}

output "replica_arn" {
    value       = module.mysql_replica.arn
    description = "ARN de la db replica"
  
}