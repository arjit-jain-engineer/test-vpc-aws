output "key_pair_name" {
  description = "AWS Key Pair ka naam — EC2 module mein pass karo"
  value       = aws_key_pair.main.key_name
}

output "pem_file_path" {
  description = "Local machine pe .pem file ki location"
  value       = local_file.private_key.filename
}

output "private_key_pem" {
  description = "Private key content — sensitive hai"
  value       = tls_private_key.main.private_key_pem
  sensitive   = true
}
