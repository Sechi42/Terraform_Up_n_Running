output "parent_account_id" {
    value       = data.aws_caller_identity.parent.id
    description = "Id de la cuenta padre"
}

output "child_account_id" {
    value       = data.aws_caller_identity.child.id
    description = "Id de la cuenta padre"
}