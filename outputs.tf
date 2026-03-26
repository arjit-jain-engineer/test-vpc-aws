# ─────────────────────────────────────────────────────────────
# outputs.tf  —  Root module outputs
# terraform apply ke baad yeh values terminal mein dikhegi
# ─────────────────────────────────────────────────────────────

# ── Key Pair ───────────────────────────────────────────────
output "key_pair_name" {
  description = "AWS mein bani Key Pair ka naam"
  value       = module.key_pair.key_pair_name
}

output "pem_file_path" {
  description = "Local machine pe .pem file kahan save hui"
  value       = module.key_pair.pem_file_path
}

output "private_key_pem" {
  description = "Private key — sensitive, screen pe nahi dikhegi"
  value       = module.key_pair.private_key_pem
  sensitive   = true
}

# ── Network ────────────────────────────────────────────────
output "vpc_id" {
  description = "VPC ka ID"
  value       = module.vpc.vpc_id
}

output "public_subnet_id" {
  description = "Public subnet ka ID"
  value       = module.subnets.public_subnet_id
}

output "private_subnet_id" {
  description = "Private subnet ka ID"
  value       = module.subnets.private_subnet_id
}

output "nat_gateway_id" {
  description = "NAT Gateway ka ID"
  value       = module.nat_gateway.nat_gateway_id
}

# ── EC2 ────────────────────────────────────────────────────
output "public_ec2_public_ip" {
  description = "Public EC2 ka Public IP — isse seedha SSH karo"
  value       = module.ec2.public_ec2_public_ip
}

output "private_ec2_private_ip" {
  description = "Private EC2 ka Private IP — public EC2 se hop karke SSH karo"
  value       = module.ec2.private_ec2_private_ip
}

output "ssh_command_public" {
  description = "Public EC2 SSH command"
  value       = "ssh -i ${module.key_pair.pem_file_path} ec2-user@${module.ec2.public_ec2_public_ip}"
}

output "ssh_command_private" {
  description = "Private EC2 SSH command (public EC2 ke andar se chalao)"
  value       = "ssh -i ${module.key_pair.pem_file_path} ec2-user@${module.ec2.private_ec2_private_ip}"
}
