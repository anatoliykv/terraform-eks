variable "tags" {}
variable "hosted_zone" {}
variable "cluster_endpoint_public_access_cidrs" {
  type = list(string)
}
variable "cluster_name" {
  type = string
}