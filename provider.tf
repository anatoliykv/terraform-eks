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
  region = "us-east-1"
}

data "aws_eks_cluster" "default" {
  count = var.cluster_name == "" ? 0 : 1
  name  = module.eks[0].cluster_id
}

data "aws_eks_cluster_auth" "default" {
  count = var.cluster_name == "" ? 0 : 1
  name  = module.eks[0].cluster_id
}

provider "kubernetes" {
  host                   = var.cluster_name == "" ? "" : data.aws_eks_cluster.default[0].endpoint
  cluster_ca_certificate = var.cluster_name == "" ? "" : base64decode(data.aws_eks_cluster.default[0].certificate_authority[0].data)
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    args        = ["eks", "get-token", "--cluster-name", var.cluster_name]
    command     = "aws"
  }
}

provider "helm" {
  kubernetes {
    host                   = var.cluster_name == "" ? "" : data.aws_eks_cluster.default[0].endpoint
    cluster_ca_certificate = var.cluster_name == "" ? "" : base64decode(data.aws_eks_cluster.default[0].certificate_authority[0].data)
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--cluster-name", var.cluster_name]
      command     = "aws"
    }
  }
}
