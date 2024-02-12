module "elb_controller_irsa_role" {
  source    = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version   = "5.34.0"
  role_name = "${var.cluster_name}-elb-controller"

  attach_load_balancer_controller_policy = true

  oidc_providers = {
    main = {
      provider_arn               = var.cluster_oidc_provider_arn
      namespace_service_accounts = ["${var.k8s_service_account_namespace}:${var.k8s_service_account_name}"]
    }
  }
  tags = local.tags
}