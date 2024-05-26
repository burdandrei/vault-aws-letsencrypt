resource "random_pet" "env" {
  length    = 2
  separator = "-"
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  name   = random_pet.env.id
  cidr   = var.cidr

  azs            = slice(data.aws_availability_zones.available.*.names[0], 0, 3)
  public_subnets = var.public_subnets
  public_subnet_tags = {
    Name = "${random_pet.env.id}-public"
  }
  enable_dns_hostnames        = true
  enable_ipv6                 = true
  public_subnet_ipv6_prefixes = [0, 1, 2]

  tags = {
    Terraform = "true"
    Name      = random_pet.env.id
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}

