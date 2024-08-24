# Terraform EKS Module

This Terraform module simplifies the deployment of an Amazon Elastic Kubernetes Service (EKS) cluster on AWS. It abstracts the complexity of EKS configuration, enabling users to quickly and efficiently set up a production-ready Kubernetes cluster.

## Key Features

- **Automated EKS Deployment**: The module automates the creation of all necessary AWS resources, including VPC, subnets, security groups, IAM roles, and EKS itself.
- **Highly Configurable**: Users can customize the EKS cluster by specifying parameters such as the number of nodes, instance types, networking configurations, and more, making it adaptable to different use cases.
- **Integrated Add-ons**: The module supports the installation of common Kubernetes add-ons such as CoreDNS, kube-proxy, and AWS VPC CNI, ensuring that the cluster is ready for production workloads.
- **Security and Best Practices**: It adheres to AWS best practices for security and scalability, including private networking, secure IAM roles, and encryption options.
- **Modular Architecture**: The module is designed to be modular, allowing users to easily integrate it into existing Terraform configurations or extend its functionality as needed.
- **Documentation and Examples**: Comprehensive documentation and example configurations are provided to help users get started quickly and understand the various customization options.

## Use Cases

- **Development and Testing**: Quickly spin up EKS clusters for development and testing purposes with minimal configuration.
- **Production Workloads**: Deploy highly available and secure Kubernetes clusters for production workloads.
- **CI/CD Integration**: Integrate with CI/CD pipelines for automated infrastructure provisioning and management.

## Getting Started

### Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) installed on your local machine.
- AWS account credentials with appropriate permissions.

### Usage

To use this module, include it in your Terraform configuration as follows:

```hcl
module "eks_cluster" {
  source = "github.com/anatoliykv/terraform-eks"

  # Customize the following variables as needed
  cluster_name = "my-eks-cluster"
  node_count   = 3
  instance_type = "t3.medium"
  region       = "us-west-2"

  # Additional configuration options...
}
