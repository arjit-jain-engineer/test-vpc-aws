# AWS VPC — Terraform Infrastructure

This Terraform project provisions a **production-ready AWS VPC** with public and private subnets, a NAT Gateway, auto-generated SSH key pair, and two EC2 instances.

---

## Architecture

```
                        Internet
                           │
                           ▼
                   Internet Gateway
                           │
                           ▼
        ┌──────────────────────────────────────────┐
        │             VPC (10.0.0.0/16)             │
        │                                           │
        │   ┌───────────────┐   ┌────────────────┐  │
        │   │ Public Subnet │   │ Private Subnet │  │
        │   │ 10.0.0.0/24   │   │ 10.0.1.0/24    │  │
        │   │               │   │                │  │
        │   │  [Public EC2] │   │ [Private EC2]  │  │
        │   │  [NAT Gateway]│──▶│                │  │
        │   └───────────────┘   └────────────────┘  │
        └──────────────────────────────────────────┘

Public EC2   →  Direct internet access via Internet Gateway
Private EC2  →  Outbound-only internet access via NAT Gateway
```

---

## Folder Structure

```
terraform-vpc/
├── main.tf               ← Root: calls all child modules
├── variables.tf          ← All variable definitions
├── outputs.tf            ← Final outputs (IPs, SSH commands)
├── provider.tf           ← AWS + TLS + Local provider config
├── terraform.tfvars      ← Your actual values
├── .gitignore
└── modules/
    ├── key-pair/         ← Generates RSA key, uploads to AWS, saves .pem locally
    ├── vpc/              ← VPC + Internet Gateway
    ├── subnets/          ← Public/Private Subnets + Route Tables
    ├── nat-gateway/      ← Elastic IP + NAT Gateway
    ├── security-groups/  ← Public SG + Private SG
    └── ec2/              ← Public EC2 + Private EC2
```

---

## Modules Overview

### `key-pair`
- Generates a 4096-bit RSA private key locally
- Uploads the public key to AWS as a Key Pair
- Saves the private key as a `.pem` file on your local machine

### `vpc`
- Creates the VPC (`10.0.0.0/16`)
- Attaches an Internet Gateway

### `subnets`
- **Public Subnet** (`10.0.0.0/24`) — Route: `0.0.0.0/0 → IGW`
- **Private Subnet** (`10.0.1.0/24`) — Route: `0.0.0.0/0 → NAT Gateway`

### `nat-gateway`
- Allocates an Elastic IP
- Creates a NAT Gateway inside the public subnet
- Enables outbound internet access for private EC2

### `security-groups`
- **Public SG** — Allows SSH (your IP only), HTTP, HTTPS, ICMP
- **Private SG** — Allows SSH and ICMP only from the public subnet

### `ec2`
- **Public EC2** — Launched in public subnet with a public IP
- **Private EC2** — Launched in private subnet with private IP only

---

## Variables

| Variable | Description | Default |
|---|---|---|
| `aws_region` | AWS Region to deploy resources | `ap-south-1` |
| `project_name` | Prefix used in all resource names | `my-project` |
| `vpc_cidr` | CIDR block for the VPC | `10.0.0.0/16` |
| `public_subnet_cidr` | CIDR block for the public subnet | `10.0.0.0/24` |
| `private_subnet_cidr` | CIDR block for the private subnet | `10.0.1.0/24` |
| `availability_zone` | AWS Availability Zone | `ap-south-1a` |
| `ec2_ami` | AMI ID for EC2 instances | Amazon Linux 2 Mumbai |
| `ec2_instance_type` | EC2 instance type | `t2.micro` |
| `my_ip` | Your public IP for SSH access (x.x.x.x/32) | — |

---

## Prerequisites

```bash
# 1. Check Terraform version (>= 1.3.0 required)
terraform -version

# 2. Verify AWS CLI is configured
aws sts get-caller-identity   # shows your account ID

# If not configured yet:
aws configure --profile my-profile
```

---

## Setup & Deploy

### Step 1 — Update `terraform.tfvars`

```hcl
project_name = "my-project"      # choose any name
my_ip        = "103.x.x.x/32"   # run: curl ifconfig.me
```

### Step 2 — Deploy

```bash
# Download required providers
terraform init

# Preview what will be created
terraform plan

# Create all resources
terraform apply
```

### Step 3 — View Outputs

```bash
terraform output
```

Expected output:
```
key_pair_name          = "my-project-key"
pem_file_path          = "./my-project-key.pem"
public_ec2_public_ip   = "13.x.x.x"
private_ec2_private_ip = "10.0.1.x"
ssh_command_public     = "ssh -i ./my-project-key.pem ec2-user@13.x.x.x"
ssh_command_private    = "ssh -i ./my-project-key.pem ec2-user@10.0.1.x"
```

---

## SSH Access

```bash
# Step 1: SSH into the Public EC2 (directly from internet)
ssh -i ./my-project-key.pem ec2-user@<public_ec2_public_ip>

# Step 2: From Public EC2, hop into the Private EC2 (bastion pattern)
ssh -i ./my-project-key.pem ec2-user@<private_ec2_private_ip>

# Step 3: Test outbound internet from Private EC2
ping google.com   # works via NAT Gateway ✅
```

---

## Cleanup

```bash
# Destroy all resources to avoid unnecessary charges
terraform destroy
```

> ⚠️ **NAT Gateway incurs hourly charges.** Always run `terraform destroy` when you are done testing.

---

## Security Notes

| File | Risk | Action |
|---|---|---|
| `terraform.tfvars` | Contains your IP | Never commit — already in `.gitignore` |
| `*.pem` | Private SSH key | Never share or commit |
| `*.tfstate` | Contains resource secrets | Never commit — already in `.gitignore` |
| `my_ip` | SSH access control | Never use `0.0.0.0/0` in production |