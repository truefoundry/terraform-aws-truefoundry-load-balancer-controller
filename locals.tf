locals {
  tags = merge(
    var.disable_default_tags ? {} : {
      "terraform-module" = "load-balancer-controller"
      "terraform"        = "true"
      "cluster-name"     = var.cluster_name
    },
    var.tags
  )
  elb_controller_policy_default_prefix = "${var.cluster_name}-elb-controller-policy-"

  elb_controller_policy_prefix = var.elb_controller_policy_prefix_enable_override ? "${var.elb_controller_policy_prefix_override_name}-${local.elb_controller_policy_default_prefix}" : local.elb_controller_policy_default_prefix

  # AWS IAM role name max length is 64 chars. When use_name_prefix is true,
  # the AWS provider appends a 26-char random suffix, so the prefix must
  # be <= 38 chars. We use 37 to match prior v0.2.0 behavior.
  elb_controller_role_name_max_length  = var.elb_controller_use_name_prefix ? 37 : 64
  elb_controller_role_default_raw_name = "${var.cluster_name}-elb-controller"
  elb_controller_role_default_name     = substr(local.elb_controller_role_default_raw_name, 0, local.elb_controller_role_name_max_length)
  elb_controller_role_resolved_name    = var.elb_controller_role_enable_override ? var.elb_controller_role_override_name : local.elb_controller_role_default_name

  elb_oidc_namespace_service_account = "${var.k8s_service_account_namespace}:${var.k8s_service_account_name}"
}