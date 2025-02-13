# terraform-aws-truefoundry-load-balancer-controller
Terraform module to spin up AWS IAM load balancer controller

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.4 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.57 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_elb_controller_irsa_role"></a> [elb\_controller\_irsa\_role](#module\_elb\_controller\_irsa\_role) | terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks | 5.52.2 |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | EKS Cluster Name | `string` | n/a | yes |
| <a name="input_cluster_oidc_provider_arn"></a> [cluster\_oidc\_provider\_arn](#input\_cluster\_oidc\_provider\_arn) | The oidc provider ARN of the eks cluster | `string` | n/a | yes |
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