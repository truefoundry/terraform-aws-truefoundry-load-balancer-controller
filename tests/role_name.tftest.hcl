mock_provider "aws" {
  # Override defaults that fail upstream AWS-side validation (JSON / ARN prefix).
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
  k8s_service_account_namespace = "aws-load-balancer-controller"
  cluster_oidc_provider_arn     = "arn:aws:iam::123456789012:oidc-provider/oidc.eks.us-east-1.amazonaws.com/id/EXAMPLED539D4633E53DE1B71EXAMPLE"
}

run "short_name_no_prefix_untrimmed" {
  variables {
    cluster_name                   = "tfy-abc"
    elb_controller_use_name_prefix = false
  }
  assert {
    condition     = output.elb_iam_role_computed_name == "tfy-abc-elb-controller"
    error_message = "Got: ${output.elb_iam_role_computed_name}"
  }
  assert {
    condition     = length(output.elb_iam_role_computed_name) <= 64
    error_message = "Computed name exceeds AWS IAM role name hard limit of 64 chars: ${output.elb_iam_role_computed_name} (len ${length(output.elb_iam_role_computed_name)})"
  }
}

run "short_name_with_prefix_untrimmed" {
  variables {
    cluster_name                   = "tfy-abc"
    elb_controller_use_name_prefix = true
  }
  assert {
    condition     = output.elb_iam_role_computed_name == "tfy-abc-elb-controller"
    error_message = "Got: ${output.elb_iam_role_computed_name}"
  }
  assert {
    condition     = length(output.elb_iam_role_computed_name) <= 64
    error_message = "Computed name exceeds AWS IAM role name hard limit of 64 chars: ${output.elb_iam_role_computed_name} (len ${length(output.elb_iam_role_computed_name)})"
  }
}

# Regression: 40-char name was truncated to 37 in v0.2.0 when use_name_prefix=false.
run "regression_40char_no_prefix_must_not_truncate" {
  variables {
    cluster_name                   = "tfy-abc-computeplane-play"
    elb_controller_use_name_prefix = false
  }
  assert {
    condition     = output.elb_iam_role_computed_name == "tfy-abc-computeplane-play-elb-controller"
    error_message = "Regression: 40-char name was truncated when use_name_prefix=false. Got: ${output.elb_iam_role_computed_name}"
  }
  assert {
    condition     = length(output.elb_iam_role_computed_name) <= 64
    error_message = "Computed name exceeds AWS IAM role name hard limit of 64 chars: ${output.elb_iam_role_computed_name} (len ${length(output.elb_iam_role_computed_name)})"
  }
}

run "long_name_with_prefix_truncated_to_37" {
  variables {
    cluster_name                   = "tfy-abc-computeplane-play"
    elb_controller_use_name_prefix = true
  }
  assert {
    condition     = output.elb_iam_role_computed_name == "tfy-abc-computeplane-play-elb-control"
    error_message = "Got: ${output.elb_iam_role_computed_name}"
  }
  assert {
    condition     = length(output.elb_iam_role_computed_name) <= 64
    error_message = "Computed name exceeds AWS IAM role name hard limit of 64 chars: ${output.elb_iam_role_computed_name} (len ${length(output.elb_iam_role_computed_name)})"
  }
}

run "very_long_name_no_prefix_truncated_to_64" {
  variables {
    cluster_name                   = "tfy-abc-computeplane-play-with-extra-very-long-segments-here"
    elb_controller_use_name_prefix = false
  }
  assert {
    condition     = length(output.elb_iam_role_computed_name) == 64
    error_message = "Expected length 64, got ${length(output.elb_iam_role_computed_name)}: ${output.elb_iam_role_computed_name}"
  }
  assert {
    condition     = length(output.elb_iam_role_computed_name) <= 64
    error_message = "Computed name exceeds AWS IAM role name hard limit of 64 chars: ${output.elb_iam_role_computed_name} (len ${length(output.elb_iam_role_computed_name)})"
  }
}

run "override_takes_precedence_over_truncation" {
  variables {
    cluster_name                        = "tfy-abc-computeplane-play"
    elb_controller_use_name_prefix      = false
    elb_controller_role_enable_override = true
    elb_controller_role_override_name   = "my-custom-role-name-that-is-deliberately-long"
  }
  assert {
    condition     = output.elb_iam_role_computed_name == "my-custom-role-name-that-is-deliberately-long"
    error_message = "Override should be used verbatim. Got: ${output.elb_iam_role_computed_name}"
  }
  assert {
    condition     = length(output.elb_iam_role_computed_name) <= 64
    error_message = "Computed name exceeds AWS IAM role name hard limit of 64 chars: ${output.elb_iam_role_computed_name} (len ${length(output.elb_iam_role_computed_name)})"
  }
}

# 22 + 15 = 37, at the prefix-branch cap — must not truncate.
run "boundary_37char_with_prefix_no_trim" {
  variables {
    cluster_name                   = "tfy-cluster-aaaaaaaaaa"
    elb_controller_use_name_prefix = true
  }
  assert {
    condition     = output.elb_iam_role_computed_name == "tfy-cluster-aaaaaaaaaa-elb-controller"
    error_message = "Got: ${output.elb_iam_role_computed_name}"
  }
  assert {
    condition     = length(output.elb_iam_role_computed_name) == 37
    error_message = "Expected length 37, got ${length(output.elb_iam_role_computed_name)}"
  }
  assert {
    condition     = length(output.elb_iam_role_computed_name) <= 64
    error_message = "Computed name exceeds AWS IAM role name hard limit of 64 chars: ${output.elb_iam_role_computed_name} (len ${length(output.elb_iam_role_computed_name)})"
  }
}

# 23 + 15 = 38, one over the prefix-branch cap — must truncate to 37.
run "boundary_38char_with_prefix_trimmed_to_37" {
  variables {
    cluster_name                   = "tfy-cluster-aaaaaaaaaaa"
    elb_controller_use_name_prefix = true
  }
  assert {
    condition     = output.elb_iam_role_computed_name == "tfy-cluster-aaaaaaaaaaa-elb-controlle"
    error_message = "Got: ${output.elb_iam_role_computed_name}"
  }
  assert {
    condition     = length(output.elb_iam_role_computed_name) == 37
    error_message = "Expected length 37, got ${length(output.elb_iam_role_computed_name)}"
  }
  assert {
    condition     = length(output.elb_iam_role_computed_name) <= 64
    error_message = "Computed name exceeds AWS IAM role name hard limit of 64 chars: ${output.elb_iam_role_computed_name} (len ${length(output.elb_iam_role_computed_name)})"
  }
}

# 49 + 15 = 64, at the no-prefix cap — must not truncate.
run "boundary_64char_no_prefix_no_trim" {
  variables {
    cluster_name                   = "tfy-cluster-aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
    elb_controller_use_name_prefix = false
  }
  assert {
    condition     = output.elb_iam_role_computed_name == "tfy-cluster-aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa-elb-controller"
    error_message = "Got: ${output.elb_iam_role_computed_name}"
  }
  assert {
    condition     = length(output.elb_iam_role_computed_name) == 64
    error_message = "Expected length 64, got ${length(output.elb_iam_role_computed_name)}"
  }
  assert {
    condition     = length(output.elb_iam_role_computed_name) <= 64
    error_message = "Computed name exceeds AWS IAM role name hard limit of 64 chars: ${output.elb_iam_role_computed_name} (len ${length(output.elb_iam_role_computed_name)})"
  }
}

# 50 + 15 = 65, one over the no-prefix cap — must truncate to 64.
run "boundary_65char_no_prefix_trimmed_to_64" {
  variables {
    cluster_name                   = "tfy-cluster-aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
    elb_controller_use_name_prefix = false
  }
  assert {
    condition     = output.elb_iam_role_computed_name == "tfy-cluster-aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa-elb-controlle"
    error_message = "Got: ${output.elb_iam_role_computed_name}"
  }
  assert {
    condition     = length(output.elb_iam_role_computed_name) == 64
    error_message = "Expected length 64, got ${length(output.elb_iam_role_computed_name)}"
  }
  assert {
    condition     = length(output.elb_iam_role_computed_name) <= 64
    error_message = "Computed name exceeds AWS IAM role name hard limit of 64 chars: ${output.elb_iam_role_computed_name} (len ${length(output.elb_iam_role_computed_name)})"
  }
}

# Override must bypass truncation on the prefix branch (kept <38 to satisfy upstream).
run "override_with_prefix_takes_precedence" {
  variables {
    cluster_name                        = "tfy-abc-computeplane-play"
    elb_controller_use_name_prefix      = true
    elb_controller_role_enable_override = true
    elb_controller_role_override_name   = "short-override-name"
  }
  assert {
    condition     = output.elb_iam_role_computed_name == "short-override-name"
    error_message = "Override should be used verbatim even when use_name_prefix=true. Got: ${output.elb_iam_role_computed_name}"
  }
  assert {
    condition     = length(output.elb_iam_role_computed_name) <= 64
    error_message = "Computed name exceeds AWS IAM role name hard limit of 64 chars: ${output.elb_iam_role_computed_name} (len ${length(output.elb_iam_role_computed_name)})"
  }
}

# Guards the "<namespace>:<service_account>" interpolation in locals.tf.
run "oidc_namespace_service_account_interpolation" {
  variables {
    cluster_name                  = "tfy-abc"
    k8s_service_account_namespace = "kube-system"
    k8s_service_account_name      = "alb-controller-sa"
  }
  assert {
    condition     = local.elb_oidc_namespace_service_account == "kube-system:alb-controller-sa"
    error_message = "OIDC binding should be '<namespace>:<service_account>'. Got: ${local.elb_oidc_namespace_service_account}"
  }
}
