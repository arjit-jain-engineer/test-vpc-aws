variable "aws_region" {
  description = "AWS region jahan resources banengi"
  type        = string
  default     = "ap-south-1"
}

variable "project_name" {
  description = "Project ka naam - sab resources mein prefix ki tarah use hoga"
  type        = string
  default     = "my-project"
}

variable "vpc_cidr" {
  description = "VPC ka CIDR block"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "Public subnet ka CIDR block"
  type        = string
  default     = "10.0.0.0/24"
}

variable "private_subnet_cidr" {
  description = "Private subnet ka CIDR block"
  type        = string
  default     = "10.0.1.0/24"
}

variable "availability_zone" {
  description = "Availability zone"
  type        = string
  default     = "ap-south-1a"
}

variable "ec2_ami" {
  description = "EC2 ke liye AMI ID (Amazon Linux 2 - Mumbai)"
  type        = string
  default     = "ami-0f58b397bc5c1f2e8"
}

variable "ec2_instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "my_ip" {
  description = "Tera public IP address SSH access ke liye (format: x.x.x.x/32)"
  type        = string
}
