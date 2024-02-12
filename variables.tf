variable "cluster_name" {
  description = "EKS Cluster Name"
  type        = string
}

variable "k8s_service_account_name" {
  description = "The k8s elb controller service account name"
  type        = string
}

variable "k8s_service_account_namespace" {
  description = "The k8s elb controller namespace"
  type        = string
}

variable "cluster_oidc_provider_arn" {
  description = "The oidc provider ARN of the eks cluster"
  type        = string
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "AWS Tags common to all the resources created"
}