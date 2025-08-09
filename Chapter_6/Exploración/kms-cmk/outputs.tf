
output "cmk_id" {
  description = "ID de la clave KMS (CMK)"
  value       = aws_kms_key.cmk.id
}

output "cmk_arn" {
  description = "ARN de la clave KMS (CMK)"
  value       = aws_kms_key.cmk.arn
}

output "cmk_alias" {
  description = "Alias de la clave KMS (CMK)"
  value       = aws_kms_alias.cmk.name
}
