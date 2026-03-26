# ─────────────────────────────────────────────────────────────
# main.tf  —  Root module
# ─────────────────────────────────────────────────────────────

module "key_pair" {
  source       = "./modules/key-pair"
  project_name = var.project_name
}

module "vpc" {
  source       = "./modules/vpc"
  project_name = var.project_name
  vpc_cidr     = var.vpc_cidr
}

module "subnets" {
  source              = "./modules/subnets"
  project_name        = var.project_name
  vpc_id              = module.vpc.vpc_id
  igw_id              = module.vpc.igw_id
  public_subnet_cidr  = var.public_subnet_cidr
  private_subnet_cidr = var.private_subnet_cidr
  availability_zone   = var.availability_zone
  nat_gateway_id      = module.nat_gateway.nat_gateway_id
}

module "nat_gateway" {
  source            = "./modules/nat-gateway"
  project_name      = var.project_name
  public_subnet_id  = module.subnets.public_subnet_id
}

module "security_groups" {
  source       = "./modules/security-groups"
  project_name = var.project_name
  vpc_id       = module.vpc.vpc_id
  my_ip        = var.my_ip
  public_subnet_cidr = var.public_subnet_cidr
}

module "ec2" {
  source                   = "./modules/ec2"
  project_name             = var.project_name
  ec2_ami                  = var.ec2_ami
  ec2_instance_type        = var.ec2_instance_type
  key_pair_name            = module.key_pair.key_pair_name
  public_subnet_id         = module.subnets.public_subnet_id
  private_subnet_id        = module.subnets.private_subnet_id
  public_security_group_id = module.security_groups.public_sg_id
  private_security_group_id = module.security_groups.private_sg_id
}
