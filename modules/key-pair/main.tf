# ─────────────────────────────────────────────────────────────
# modules/key-pair/main.tf
# ─────────────────────────────────────────────────────────────

# Step 1: RSA Private Key generate karo
resource "tls_private_key" "main" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Step 2: AWS mein Key Pair banao (public key upload hogi)
resource "aws_key_pair" "main" {
  key_name   = "${var.project_name}-key"
  public_key = tls_private_key.main.public_key_openssh
}

# Step 3: Private key ko local .pem file mein save karo
resource "local_file" "private_key" {
  content         = tls_private_key.main.private_key_pem
  filename        = "${path.root}/${var.project_name}-key.pem"
  file_permission = "0400" # sirf owner read kar sake — SSH ke liye zaroori
}
