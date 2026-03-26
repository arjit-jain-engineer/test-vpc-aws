# ─────────────────────────────────────────────────────────────
# modules/ec2/main.tf
# ─────────────────────────────────────────────────────────────

# ── Public EC2 ────────────────────────────────────────────
resource "aws_instance" "public" {
  ami                    = var.ec2_ami
  instance_type          = var.ec2_instance_type
  subnet_id              = var.public_subnet_id
  vpc_security_group_ids = [var.public_security_group_id]
  key_name               = var.key_pair_name

  tags = {
    Name = "${var.project_name}-public-ec2"
  }
}

# ── Private EC2 ───────────────────────────────────────────
resource "aws_instance" "private" {
  ami                    = var.ec2_ami
  instance_type          = var.ec2_instance_type
  subnet_id              = var.private_subnet_id
  vpc_security_group_ids = [var.private_security_group_id]
  key_name               = var.key_pair_name

  tags = {
    Name = "${var.project_name}-private-ec2"
  }
}
