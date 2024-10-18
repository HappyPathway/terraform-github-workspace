module "actions_environment_variables" {
  source = "./modules/actions_environment_variables"
  for_each = toset([
    var.environment,
    "${var.environment}-staging"
  ])
  secrets     = var.secrets
  vars        = var.vars
  environment = each.value
  repo_name   = data.github_repository.repo.name
}
