terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  #   required_version = ">= 1.2.0"
}

provider "aws" {
  region     = local.region_name
  access_key = local.access_key
  secret_key = local.secret_key
}

# resource "aws_instance" "app_server" {
#   ami           = module.aws_ami.aws_linux_id
#   instance_type = "t2.micro"

#   tags = {
#     Name = "Sample EC2 Server"
#   }
# }

module "aws_ami" {
  source = "./aws_ami"
}


################################################################################
# EC2 Module
################################################################################

module "ec2" {
  source = "./aws_instance"

  name = local.instance_name

  ami                         = module.aws_ami.ubuntu_20_04_id
  instance_type               = local.instance_type
  availability_zone           = element(local.azs, 0)
  subnet_id                   = element(module.vpc.public_subnets, 0)
  vpc_security_group_ids      = [module.security_group.security_group_id]
  associate_public_ip_address = local.use_public_ip
  key_name                    = module.ec2_key.key_name
  tags                        = local.tags
  # user_data                   = file("init.sh")
}

# module "ec2_new" {
#   source = "./aws_instance"

#   name = local.instance_name

#   ami                         = module.aws_ami.ubuntu_20_04_id
#   instance_type               = local.instance_type
#   availability_zone           = element(local.azs, 0)
#   subnet_id                   = element(module.vpc.public_subnets, 0)
#   vpc_security_group_ids      = [module.security_group.security_group_id]
#   associate_public_ip_address = local.use_public_ip
#   key_name                    = module.ec2_key.key_name
#   tags                        = local.tags
#   user_data                   = file("init.sh")
# }

# resource "aws_volume_attachment" "this" {
#   device_name = "/dev/sdh"
#   volume_id   = aws_ebs_volume.this.id
#   instance_id = module.ec2.id
# }

# resource "aws_ebs_volume" "this" {
#   availability_zone = element(local.azs, 0)
#   size              = 1

#   tags = local.tags
# }

###############################################################################
# Supporting Resources
###############################################################################

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 4.0"

  name = local.vpc_name
  cidr = local.vpc_cidr

  azs             = local.azs
  private_subnets = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 4, k)]
  public_subnets  = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 48)]

  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = local.tags
}

# data "github_actions_registration_token" "example" {
#   repository = "aimarker/MLOPs_AI"
# }

module "security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 4.0"

  name        = local.name
  description = "Security group for example usage with EC2 instance"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["all-all"]
  egress_rules        = ["all-all"]

  tags = local.tags
}

resource "aws_route" "route_with_ig" {
  for_each = toset(concat(module.vpc.public_route_table_ids))

  route_table_id         = each.key
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = module.vpc.igw_id
}

module "ec2_key" {
  source = "./aws_key_pair"

  algorithm = "RSA"
  rsa_bits  = 4096

  pem_file_name = local.pem_file_name
}

# resource "aws_instance" "fast_api_server" {
#   ami           = data.aws_ami.ubuntu.id
#   instance_type = "t3.micro"
#   tags = {
#     name = "Fast API Server on EC2"
#   }
# }

# resource "aws_ec2_instance_state" "app_server_state" {
#   instance_id = module.ec2.id
#   state       = "stopped"
#   force       = true
# }


###############################################################################
# Cloud 9 instances
###############################################################################

# resource "aws_cloud9_environment_ec2" "cloud9_server" {
#   instance_type = "t2.micro"
#   name          = "cloud9-dev"
# }

# resource "aws_cloud9_environment_ec2" "cloud9_server" {
#   instance_type = "t2.micro"
#   name          = "MLOPs_CDS"
# }
