module "eks" {
#  create = var.create
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 18.26"

  cluster_name    = var.cluster_name
  cluster_version = "1.22"

  cluster_endpoint_private_access      = true
  cluster_endpoint_public_access       = true
  cluster_endpoint_public_access_cidrs = concat(["${chomp(data.http.myip.body)}/32"], var.cluster_endpoint_public_access_cidrs)

  vpc_id     = var.vpc_id
  subnet_ids = var.subnets

  enable_irsa = true

  cluster_addons = {
    coredns = {
      addon_version     = "v1.8.7-eksbuild.1"
      resolve_conflicts = "OVERWRITE"
    }
    kube-proxy = {
      addon_version     = "v1.22.11-eksbuild.2"
      resolve_conflicts = "OVERWRITE"
    }
    vpc-cni = {
      addon_version     = "v1.11.2-eksbuild.1"
      resolve_conflicts = "OVERWRITE"
    }
  }

#  create_aws_auth_configmap = true
  manage_aws_auth_configmap = true

  eks_managed_node_groups = {
    test = {
      min_size               = 1
      max_size               = 5
      desired_size           = 2
      instance_types         = ["t3.large"]
      capacity_type          = "ON_DEMAND"
      create_launch_template = false
      launch_template_name   = ""
    }
    test_2 = {
      min_size               = 1
      max_size               = 10
      desired_size           = 3
      instance_types         = ["t3.large"]
      capacity_type          = "ON_DEMAND"
      create_launch_template = false
      launch_template_name   = ""
    }
  }

  cluster_enabled_log_types = [
    "audit",
    "api",
    "authenticator",
    "scheduler",
    "controllerManager"
  ]

  tags = var.tags
}

data "http" "myip" {
  url = "http://ipv4.icanhazip.com"
}
