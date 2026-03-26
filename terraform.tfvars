# ─────────────────────────────────────────────────────────────
# terraform.tfvars
# Yahan apni actual values daal - yeh file .gitignore mein daalna!
# ─────────────────────────────────────────────────────────────

aws_region          = "ap-south-1"
project_name        = "ArjitTest"

vpc_cidr            = "10.0.0.0/16"
public_subnet_cidr  = "10.0.0.0/24"
private_subnet_cidr = "10.0.1.0/24"
availability_zone   = "ap-south-1a"

ec2_ami             = "ami-0f58b397bc5c1f2e8"  # Amazon Linux 2 - Mumbai
ec2_instance_type   = "t2.micro"

my_ip               = "0.0.0.0/0" 
