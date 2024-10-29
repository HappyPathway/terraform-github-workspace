# Retrieve information about a GitHub user.



# Resource to create a GitHub repository environment
resource "github_repository_environment" "this" {
  for_each            = local.environments
  environment         = each.value.name
  repository          = local.repo.name
  prevent_self_review = each.value.prevent_self_review
  wait_timer          = each.value.wait_timer
  can_admins_bypass   = each.value.can_admins_bypass
  dynamic "reviewers" {
    for_each = toset(each.value.reviewers.enforce_reviewers ? [""] : [])
    content {
      users = lookup(local.environment_reviewers, each.key)
      teams = compact(lookup(local.environment_teams, each.key))
    }
  }
  dynamic "deployment_branch_policy" {
    for_each = toset(each.value.deployment_branch_policy.restrict_branches ? [""] : [])
    content {
      protected_branches     = each.value.deployment_branch_policy.protected_branches
      custom_branch_policies = each.value.deployment_branch_policy.custom_branch_policies
    }
  }
  depends_on = [module.repo]
}

# Resource to create a deployment branch policy for the GitHub repository environment
resource "github_repository_deployment_branch_policy" "this" {
  for_each = {
    for env in var.environments :
    env.name => env if lookup(module.context, env.name).create_deployment_branch_policy
  }
  repository       = local.repo.name
  environment_name = each.value.name
  name             = each.value.deployment_branch_policy.branch
  depends_on       = [github_repository_environment.this]
}

# Resource to create a deployment policy for the GitHub repository environment
resource "github_repository_environment_deployment_policy" "this" {
  for_each = {
    for env in var.environments :
    env.name => env if lookup(module.context, env.name).create_environment_deployment_policy
  }
  repository     = local.repo.name
  environment    = each.value.name
  branch_pattern = each.value.deployment_branch_policy.branch_pattern
  depends_on     = [github_repository_environment.this]
}
