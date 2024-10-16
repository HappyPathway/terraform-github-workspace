# github repository data source
# github_repository_environment
# github_repository_environment_deployment_policy
# github_actions_environment_secret
# github_actions_environment_variable
# github_branch_protection

data "github_repository" "repo" {
  name  = var.repo_name
  owner = var.repo_org
}

# https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository_environment
resource "github_repository_environment" "this" {
  environment         = var.environment
  repository          = data.github_repository.repo.name
  prevent_self_review = var.prevent_self_review
  reviewers {
    users = var.reviewers
    teams = var.reviewers_teams
  }
  deployment_branch_policy {
    protected_branches     = var.protected_branches
    custom_branch_policies = var.custom_branch_policies
  }
}

# https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository_environment_deployment_policy
resource "github_repository_environment_deployment_policy" "this" {
  repository     = data.github_repository.repo.name
  environment    = github_repository_environment.this.environment
  branch_pattern = var.branch_pattern
}

resource "github_actions_environment_secret" "secret" {
  for_each        = tomap({ for secret in var.secrets : secret.name => secret.value })
  secret_name     = each.key
  plaintext_value = each.value
  environment     = github_repository_environment.this.environment
}

resource "github_actions_environment_variable" "variable" {
  for_each      = tomap({ for _var in var.vars : _var.name => _var.value })
  environment   = github_repository_environment.this.environment
  variable_name = each.key
  value         = each.value
}
