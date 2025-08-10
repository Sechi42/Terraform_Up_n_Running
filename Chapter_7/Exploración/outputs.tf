output "region_1" {
  value       = data.aws_region.region_1.name
  description = "The name of the first region"
}

output "region_2" {
  value       = data.aws_region.region_2.name
  description = "The name of the second region"
}

output "instance_region_1_az" {
    value       = aws_instance.region_1.availability_zone
    description = "Zona de disponibilidad de la instancia en la región 1"
}

output "instance_region_2_az" {
    value       = aws_instance.region_2.availability_zone
    description = "Zona de disponibilidad de la instancia en la región 2"
}