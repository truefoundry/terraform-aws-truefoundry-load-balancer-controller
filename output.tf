output "elb_iam_role_arn" {
  value       = module.elb_controller_irsa_role.arn
  description = "AWS IAM role arn for the ELB controller"
}

output "elb_iam_role_name" {
  value       = module.elb_controller_irsa_role.name
  description = "AWS IAM role name for the ELB controller"
}

output "elb_iam_role_path" {
  value       = module.elb_controller_irsa_role.path
  description = "AWS IAM role path for the ELB controller"
}

output "elb_iam_role_unique_id" {
  value       = module.elb_controller_irsa_role.unique_id
  description = "AWS IAM role unique ID for the ELB controller"
}

output "elb_iam_role_computed_name" {
  value       = local.elb_controller_role_resolved_name
  description = "The IAM role name (or name_prefix when use_name_prefix=true) computed by this module before being passed to the upstream IAM module. Useful for pre-apply introspection. When use_name_prefix=true the upstream module appends a random suffix to this value."
}
