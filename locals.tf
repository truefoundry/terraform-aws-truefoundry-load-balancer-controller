locals {
  tags = merge(
    {
      "terraform-module" = "load-balancer-controller"
      "terraform"        = "true"
      "cluster-name"     = var.cluster_name
    },
    var.tags
  )
}