output "elb_iam_role_arn" {
  value       = module.elb_controller_irsa_role.iam_role_arn
  description = "AWS IAM role arn for the ELB controller"
}

output "elb_iam_role_name" {
  value       = module.elb_controller_irsa_role.iam_role_name
  description = "AWS IAM role name for the ELB controller"
}

output "elb_iam_role_path" {
  value       = module.elb_controller_irsa_role.iam_role_path
  description = "AWS IAM role path for the ELB controller"
}

output "elb_iam_role_unique_id" {
  value       = module.elb_controller_irsa_role.iam_role_unique_id
  description = "AWS IAM role unique ID for the ELB controller"
}
