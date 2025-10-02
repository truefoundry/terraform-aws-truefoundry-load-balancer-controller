module "elb_controller_irsa_role" {
  source             = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version            = "5.60.0"
  role_name          = var.elb_controller_role_enable_override ? var.elb_controller_role_override_name : "${var.cluster_name}-elb-controller"
  policy_name_prefix = local.elb_controller_policy_prefix

  attach_load_balancer_controller_policy = true

  oidc_providers = {
    main = {
      provider_arn               = var.cluster_oidc_provider_arn
      namespace_service_accounts = ["${var.k8s_service_account_namespace}:${var.k8s_service_account_name}"]
    }
  }
  role_permissions_boundary_arn = var.elb_controller_role_permissions_boundary_arn

  role_policy_arns = var.elb_controller_role_additional_policy_arns
  tags             = local.tags
}
