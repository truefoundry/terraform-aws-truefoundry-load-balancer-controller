module "elb_controller_irsa_role" {
  # source             = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  source                                 = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts"
  version                                = "6.2.3"
  name                                   = var.elb_controller_role_enable_override ? var.elb_controller_role_override_name : "${var.cluster_name}-elb-controller"
  use_name_prefix                        = var.elb_controller_use_name_prefix
  policy_name                            = local.elb_controller_policy_prefix
  attach_load_balancer_controller_policy = true
  oidc_providers = {
    main = {
      provider_arn               = var.cluster_oidc_provider_arn
      namespace_service_accounts = ["${var.k8s_service_account_namespace}:${var.k8s_service_account_name}"]
    }
  }
  permissions_boundary = var.elb_controller_role_permissions_boundary_arn
  policies             = var.elb_controller_role_additional_policies
  tags                 = local.tags
}
