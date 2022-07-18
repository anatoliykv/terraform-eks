variable "chart" {}
variable "name" {}
variable "repository" {}
variable "set" {

}
variable "values" {
  default = []
}
variable "atomic" {}
variable "namespace" {}
variable "create_namespace" {}
variable "wait" {}
variable "iam_role_name" {}
variable "bucket_arn" {
}
variable "cluster_oidc_issuer_url" {}
variable "oidc_provider_arn" {}
variable "loki_bucket_id" {}