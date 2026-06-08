# Plan-only tag propagation test — INFRA-703
# The module passes local.tags to the upstream IRSA module; there is no
# directly-owned aws_iam_policy in this module's own resource graph, so
# we assert on local.tags which feeds every taggable resource.

mock_provider "aws" {
  mock_data "aws_iam_policy_document" {
    defaults = {
      json = "{\"Version\":\"2012-10-17\",\"Statement\":[]}"
    }
  }
  mock_resource "aws_iam_policy" {
    defaults = {
      arn = "arn:aws:iam::123456789012:policy/mock-policy"
    }
  }
}

variables {
  k8s_service_account_name      = "aws-load-balancer-controller"
  k8s_service_account_namespace = "kube-system"
  cluster_oidc_provider_arn     = "arn:aws:iam::123456789012:oidc-provider/oidc.eks.us-east-1.amazonaws.com/id/EXAMPLED539D4633E53DE1B71EXAMPLE"
}

run "tags_applied" {
  command = plan

  variables {
    cluster_name = "test"
    tags         = { "cost-center" = "test-123" }
  }

  # Caller tag propagates through local.tags
  assert {
    condition     = local.tags["cost-center"] == "test-123"
    error_message = "Expected cost-center=test-123 in local.tags, got: ${local.tags["cost-center"]}"
  }

  # Module default tag is present in local.tags
  assert {
    condition     = local.tags["truefoundry-terraform-module"] == "load-balancer-controller"
    error_message = "Expected truefoundry-terraform-module=load-balancer-controller in local.tags, got: ${local.tags["truefoundry-terraform-module"]}"
  }

  # Module managed tag is present in local.tags
  assert {
    condition     = local.tags["truefoundry-managed"] == "true"
    error_message = "Expected truefoundry-managed=true in local.tags, got: ${local.tags["truefoundry-managed"]}"
  }
}

run "disable_default_tags" {
  command = plan

  variables {
    cluster_name         = "test"
    tags                 = { "cost-center" = "test-123" }
    disable_default_tags = true
  }

  # Caller tag is still present when default tags are disabled
  assert {
    condition     = local.tags["cost-center"] == "test-123"
    error_message = "Expected cost-center=test-123 in local.tags, got: ${local.tags["cost-center"]}"
  }

  # truefoundry-terraform-module must be absent when disable_default_tags=true
  assert {
    condition     = !contains(keys(local.tags), "truefoundry-terraform-module")
    error_message = "Expected truefoundry-terraform-module to be absent when disable_default_tags=true"
  }
}
