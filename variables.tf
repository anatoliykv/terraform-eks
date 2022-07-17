variable "subnets" {
  type    = list(string)
  default = []
}
variable "vpc_id" {}

variable "tags" {}
variable "hosted_zone" {}