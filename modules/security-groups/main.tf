# ─────────────────────────────────────────────────────────────
# modules/security-groups/main.tf
# ─────────────────────────────────────────────────────────────

# ── Public EC2 Security Group ──────────────────────────────
resource "aws_security_group" "public" {
  name        = "${var.project_name}-public-sg"
  description = "Public EC2: SSH sirf teri IP se, HTTP/HTTPS sab ke liye"
  vpc_id      = var.vpc_id

  # SSH — sirf tera IP
  ingress {
    description = "SSH from my IP only"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
  }

  # HTTP
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTPS
  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # ICMP (ping)
  ingress {
    description = "ICMP - Ping"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound — sab allow
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-public-sg"
  }
}

# ── Private EC2 Security Group ─────────────────────────────
resource "aws_security_group" "private" {
  name        = "${var.project_name}-private-sg"
  description = "Private EC2: sirf public subnet se SSH/ping allow"
  vpc_id      = var.vpc_id

  # SSH — sirf public subnet ke andar se (bastion se)
  ingress {
    description = "SSH from public subnet only"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.public_subnet_cidr]
  }

  # ICMP — sirf public subnet se ping
  ingress {
    description = "ICMP from public subnet"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = [var.public_subnet_cidr]
  }

  # Outbound — NAT ke through bahar jaane ke liye
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-private-sg"
  }
}
