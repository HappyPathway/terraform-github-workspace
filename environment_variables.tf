# Resource to create GitHub Actions environment secrets
resource "github_actions_environment_secret" "secret" {
  for_each        = tomap({ for secret in var.secrets : secret.name => secret.value })
  secret_name     = each.key
  plaintext_value = each.value
  environment     = local.environment
  repository      = data.github_repository.repo.name
}

# Resource to create GitHub Actions environment variables
resource "github_actions_environment_variable" "variable" {
  for_each      = tomap({ for _var in var.vars : _var.name => _var.value })
  environment   = local.environment
  variable_name = each.key
  value         = each.value
  repository    = data.github_repository.repo.name
}

resource "github_actions_environment_secret" "staging_secret" {
  for_each        = tomap({ for secret in var.secrets : secret.name => secret.value })
  secret_name     = each.key
  plaintext_value = each.value
  environment     = local.staging_environment
  repository      = data.github_repository.repo.name
}

# Resource to create GitHub Actions environment variables
resource "github_actions_environment_variable" "staging_variable" {
  for_each      = tomap({ for _var in var.vars : _var.name => _var.value })
  environment   = local.staging_environment
  variable_name = each.key
  value         = each.value
  repository    = data.github_repository.repo.name
}
