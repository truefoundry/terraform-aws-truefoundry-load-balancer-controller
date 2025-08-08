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

variable "elb_controller_role_enable_override" {
  description = "Enable/Disable override of the elb controller role name. If enabled, the elb_controller_role_name_override variable must be set."
  type        = bool
  default     = false
}

variable "elb_controller_role_override_name" {
  description = "The override name for the elb controller role. This will be used if elb_controller_role_enable_override is true."
  type        = string
  default     = ""
}

variable "elb_controller_role_permissions_boundary_arn" {
  description = "The permissions boundary ARN for the elb controller role"
  type        = string
  default     = null
}

variable "elb_controller_role_additional_policy_arns" {
  description = "The additional policy ARNs for the elb controller role. For example, { 'policy' = 'arn:aws:iam::aws:policy/PolicyName' }"
  type        = map(string)
  default     = {}
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "AWS Tags common to all the resources created"
}