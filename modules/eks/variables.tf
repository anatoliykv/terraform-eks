variable "vpc_id" {
  type = string
}
variable "subnets" {
  type = list(string)
}
variable "tags" {
  type = map(string)
}
variable "cluster_endpoint_public_access_cidrs" {
  type = list(string)
}

variable "cluster_name" {
  type = string
}