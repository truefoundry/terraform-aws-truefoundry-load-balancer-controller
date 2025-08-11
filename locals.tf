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
}