module "elb_controller_irsa_role" {
  # source             = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  source                                 = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts"
  version                                = "6.4.0"
  name                                   = local.elb_controller_role_resolved_name
  use_name_prefix                        = var.elb_controller_use_name_prefix
  policy_name                            = local.elb_controller_policy_prefix
  attach_load_balancer_controller_policy = true
  oidc_providers = {
    main = {
      provider_arn               = var.cluster_oidc_provider_arn
      namespace_service_accounts = [local.elb_oidc_namespace_service_account]
    }
  }
  permissions_boundary = var.elb_controller_role_permissions_boundary_arn
  policies             = var.elb_controller_role_additional_policies
  tags                 = local.tags
}
