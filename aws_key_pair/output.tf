output "id" {
  description = "The ID of the resource"
  value = try(
    tls_private_key.symmetric_key.id,
    null
  )
}

output "key_name" {
  description = "Name of the key"
  value = try(
    aws_key_pair.key_pair.key_name,
    null
  )
}

