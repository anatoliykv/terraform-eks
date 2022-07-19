variable "subnets" {
  type    = list(string)
  default = []
}
variable "vpc_id" {}

variable "tags" {}
variable "hosted_zone" {}
variable "cluster_endpoint_public_access_cidrs" {
  type = list(string)
}