# terraform-aws-truefoundry-load-balancer-controller
Terraform module to spin up AWS IAM load balancer controller

## Upgrade Notes

### v0.2.1 — IAM role name truncation fix

Versions `v0.2.0` of this module unconditionally truncated the computed IAM role
name to 37 characters via `substr("${var.cluster_name}-elb-controller", 0, 37)`,
even when `elb_controller_use_name_prefix = false`. This caused role names in the
38-64 character range to be destroyed and recreated under a shorter name during
the `v0.1.x` → `v0.2.0` upgrade, breaking IRSA wiring downstream.

`v0.2.1` makes the truncation conditional on `elb_controller_use_name_prefix`:

- `use_name_prefix = true` (default): name is still capped at 37 chars to leave
  room for the 26-char random suffix appended by the AWS provider (AWS IAM role
  name hard limit is 64 chars).
- `use_name_prefix = false`: name is capped at the AWS hard limit of 64 chars.
  For all realistic cluster names this is a no-op, restoring `v0.1.x` behavior.

#### Upgrading from v0.1.x → v0.2.1+

No role recreation. The fix restores the un-truncated name behavior of `v0.1.x`.

#### Upgrading from v0.2.0 → v0.2.1+

If your cluster name produced a 38-64 char default role name on `v0.2.0`, your
IAM role currently exists under a truncated name (e.g.
`tfy-abc-computeplane-play-elb-control` instead of
`tfy-abc-computeplane-play-elb-controller`). Upgrading to `v0.2.1` will restore
the full un-truncated name, causing a **one-time destroy/recreate** of the IAM
role.

To keep the current trimmed name and avoid the recreate, set the existing
override variables before upgrading:

```hcl
elb_controller_role_enable_override = true
elb_controller_role_override_name   = "<current-trimmed-name>" # e.g. "tfy-abc-computeplane-play-elb-control"
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.4 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 6.33 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_elb_controller_irsa_role"></a> [elb\_controller\_irsa\_role](#module\_elb\_controller\_irsa\_role) | terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts | 6.4.0 |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | EKS Cluster Name | `string` | n/a | yes |
| <a name="input_cluster_oidc_provider_arn"></a> [cluster\_oidc\_provider\_arn](#input\_cluster\_oidc\_provider\_arn) | The oidc provider ARN of the eks cluster | `string` | n/a | yes |
| <a name="input_disable_default_tags"></a> [disable\_default\_tags](#input\_disable\_default\_tags) | Disable the TrueFoundry module-injected audit tags (truefoundry-*); only var.tags is applied. Does NOT affect the AWS provider default\_tags. | `bool` | `false` | no |
| <a name="input_elb_controller_policy_prefix_enable_override"></a> [elb\_controller\_policy\_prefix\_enable\_override](#input\_elb\_controller\_policy\_prefix\_enable\_override) | Enable/Disable override of the elb controller policy prefix. If enabled, the elb\_controller\_policy\_prefix\_override\_name variable must be set. | `bool` | `false` | no |
| <a name="input_elb_controller_policy_prefix_override_name"></a> [elb\_controller\_policy\_prefix\_override\_name](#input\_elb\_controller\_policy\_prefix\_override\_name) | The override prefix for the elb controller policy name. This will be used if elb\_controller\_policy\_prefix\_enable\_override is true. | `string` | `""` | no |
| <a name="input_elb_controller_role_additional_policies"></a> [elb\_controller\_role\_additional\_policies](#input\_elb\_controller\_role\_additional\_policies) | The additional policies for the elb controller role. For example, { 'policy' = 'arn:aws:iam::aws:policy/PolicyName' } | `map(string)` | `{}` | no |
| <a name="input_elb_controller_role_enable_override"></a> [elb\_controller\_role\_enable\_override](#input\_elb\_controller\_role\_enable\_override) | Enable/Disable override of the elb controller role name. If enabled, the elb\_controller\_role\_name\_override variable must be set. | `bool` | `false` | no |
| <a name="input_elb_controller_role_override_name"></a> [elb\_controller\_role\_override\_name](#input\_elb\_controller\_role\_override\_name) | The override name for the elb controller role. This will be used if elb\_controller\_role\_enable\_override is true. | `string` | `""` | no |
| <a name="input_elb_controller_role_permissions_boundary_arn"></a> [elb\_controller\_role\_permissions\_boundary\_arn](#input\_elb\_controller\_role\_permissions\_boundary\_arn) | The permissions boundary ARN for the elb controller role | `string` | `null` | no |
| <a name="input_elb_controller_use_name_prefix"></a> [elb\_controller\_use\_name\_prefix](#input\_elb\_controller\_use\_name\_prefix) | Use name prefix for the elb controller role and policy. | `bool` | `true` | no |
| <a name="input_k8s_service_account_name"></a> [k8s\_service\_account\_name](#input\_k8s\_service\_account\_name) | The k8s elb controller service account name | `string` | n/a | yes |
| <a name="input_k8s_service_account_namespace"></a> [k8s\_service\_account\_namespace](#input\_k8s\_service\_account\_namespace) | The k8s elb controller namespace | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | AWS Tags common to all the resources created | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_elb_iam_role_arn"></a> [elb\_iam\_role\_arn](#output\_elb\_iam\_role\_arn) | AWS IAM role arn for the ELB controller |
| <a name="output_elb_iam_role_name"></a> [elb\_iam\_role\_name](#output\_elb\_iam\_role\_name) | AWS IAM role name for the ELB controller |
| <a name="output_elb_iam_role_path"></a> [elb\_iam\_role\_path](#output\_elb\_iam\_role\_path) | AWS IAM role path for the ELB controller |
| <a name="output_elb_iam_role_unique_id"></a> [elb\_iam\_role\_unique\_id](#output\_elb\_iam\_role\_unique\_id) | AWS IAM role unique ID for the ELB controller |
<!-- END_TF_DOCS -->