# ─────────────────────────────────────────────────────────────
# modules/nat-gateway/main.tf
# NAT Gateway PUBLIC subnet mein banta hai — yeh important hai!
# ─────────────────────────────────────────────────────────────

resource "aws_eip" "nat" {
  domain = "vpc"

  tags = {
    Name = "${var.project_name}-nat-eip"
  }
}

resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id
  subnet_id     = var.public_subnet_id   # ← Public subnet mein hoga

  tags = {
    Name = "${var.project_name}-nat-gateway"
  }
}
