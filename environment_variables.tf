module "actions_environment_variables" {
  source   = "./modules/actions_environment_variables"
  for_each = { for env in var.environments : env.name => env }
  secrets  = each.value.secrets
  vars = concat(each.value.vars,
    [
      {
        name  = "terraform_workspace"
        value = "${var.repo.name}-${each.value.name}"
      }
    ]
  )

  environment = each.value.name
  repo_name   = var.repo.name
  depends_on  = [module.repo]
}
