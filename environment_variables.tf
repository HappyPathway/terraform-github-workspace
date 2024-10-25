module "actions_environment_variables" {
  source      = "./modules/actions_environment_variables"
  for_each    = toset(var.environments)
  secrets     = each.value.secrets
  vars        = each.value.vars
  environment = each.value.name
  repo_name   = data.github_repository.repo.name
}
