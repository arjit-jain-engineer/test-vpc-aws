# AWS VPC Terraform Setup

## Architecture

```
Internet
    │
    ▼
Internet Gateway
    │
    ▼
┌─────────────────────────────────────────┐
│              VPC (10.0.0.0/16)          │
│                                         │
│  ┌──────────────────┐  ┌─────────────┐  │
│  │  Public Subnet   │  │Private Subnet│  │
│  │  10.0.0.0/24     │  │10.0.1.0/24  │  │
│  │                  │  │             │  │
│  │  [Public EC2]    │  │[Private EC2]│  │
│  │  [NAT Gateway]   │  │             │  │
│  └──────────────────┘  └─────────────┘  │
└─────────────────────────────────────────┘
```

## Folder Structure

```
terraform-vpc/
├── main.tf               ← Root: saare modules yahan call hote hain
├── variables.tf          ← Saari variables ki definition
├── outputs.tf            ← Final outputs (IPs etc.)
├── provider.tf           ← AWS provider config
├── terraform.tfvars      ← Teri actual values (git mein mat daalo!)
├── .gitignore
└── modules/
    ├── vpc/              ← VPC + Internet Gateway
    ├── subnets/          ← Public/Private subnets + Route Tables
    ├── nat-gateway/      ← Elastic IP + NAT Gateway
    ├── security-groups/  ← Public SG + Private SG
    └── ec2/              ← Public EC2 + Private EC2
```

## Setup Steps

### 1. terraform.tfvars mein apni values daal

```hcl
key_pair_name = "tera-key-pair-naam"
my_ip         = "103.x.x.x/32"   # apna IP: curl ifconfig.me
```

### 2. Commands chalao

```bash
terraform init      # providers download hoge
terraform plan      # preview - kya banega
terraform apply     # actual resources ban jayenge
terraform destroy   # sab delete karna ho toh
```

### 3. Apply ke baad SSH karo

```bash
# Step 1: Public EC2 mein jaao
ssh -i your-key.pem ec2-user@<public_ec2_public_ip>

# Step 2: Public EC2 se Private EC2 mein jaao
ssh -i your-key.pem ec2-user@<private_ec2_private_ip>

# Step 3: Private EC2 se ping test karo
ping google.com   # NAT Gateway ki wajah se kaam karega ✅
```

## Important Notes

- `terraform.tfvars` ko kabhi bhi git mein mat daalo — secrets hain
- NAT Gateway costly ho sakta hai — `terraform destroy` karna mat bhoolo
- `my_ip` mein apna sahi IP daalo warna SSH nahi hogi
