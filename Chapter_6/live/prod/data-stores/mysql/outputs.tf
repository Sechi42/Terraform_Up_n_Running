
output "address" {
    value       = aws_db_instance.example.address
    description = "Connect to the database at this endpoint"
}

# Puerto en el que escucha la base de datos
output "port" {
    value       = aws_db_instance.example.port
    description = "The port the database is listening on"
}
