locals {
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24", "10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24", "10.0.104.0/24", "10.0.105.0/24", "10.0.106.0/24"]
  private_subnets_list = flatten([
    for key, avz in data.aws_availability_zones.available.names : {
      availability_zone = avz
      private_subnet    = element(local.private_subnets, key)
      public_subnet     = element(local.public_subnets, key)
    }
    ]
  )
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "my-vpc"
  cidr = "10.0.0.0/16"

  azs             = local.private_subnets_list[*].availability_zone
  private_subnets = local.private_subnets_list[*].private_subnet
  public_subnets  = local.private_subnets_list[*].public_subnet

  enable_nat_gateway   = true
  reuse_nat_ips        = false
  single_nat_gateway   = true
  enable_dns_hostnames = true

  tags = var.tags

  private_subnet_tags = {
    "SubnetType" = "Private"
  }

  public_subnet_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                    = "1"
    "SubnetType"                                = "Public"
  }
}

data "aws_availability_zones" "available" {
  state = "available"
  exclude_names = ["us-east-1e"]
}
