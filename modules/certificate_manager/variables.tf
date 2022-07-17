variable "domain_name" {
  default = null
  type = string
}

variable "subject_alternative_names" {
  type = list(string)
  default = []
}
variable "tags" {}
variable "hosted_zone" {}