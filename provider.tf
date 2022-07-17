terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.22"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.6"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.12"
    }
  }
}

provider "aws" {
  region     = "us-east-1"
}

data "aws_eks_cluster" "default" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "default" {
  name = module.eks.cluster_id
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.default.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.default.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.default.token
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.default.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.default.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.default.token
  }
}
