variable "name" {}
variable "repository" {}
variable "chart" {}
variable "namespace" {}
variable "atomic" {}
variable "set" {
  description = "(Optional) Value block with custom values to be merged with the values yaml."
  default     = []
  type = list(object({
    name  = string
    value = string
  }))
}
variable "values" {
  type = list(string)
}

variable "wait" {}
variable "create_namespace" {}

variable "set_sensitive" {
  default = []
}