
output "review_users" {
  value = [
    for user in var.environment.reviewers.users : data.github_user.all_reviewers[user].id
  ]
}

output "review_teams" {
  value = [
    for team in var.environment.reviewers.teams : lookup(local.org_teams, team).id
  ]
}

output "create_deployment_branch_policy" {
  value = local.create_deployment_branch_policy
}

output "create_environment_deployment_policy" {
  value = local.create_environment_deployment_policy
}

output "create_branch_protection_pattern" {
  value = local.create_branch_protection_pattern
}

output "create_branch_protection_branch" {
  value = local.create_branch_protection_branch
}

output "required_status_checks_set" {
  value = local.required_status_checks_set
}

output "required_status_checks" {
  value = local.required_status_checks_set ? [var.environment.deployment_branch_policy.required_status_checks] : []
}

output "required_pull_request_reviews" {
  value = var.environment.deployment_branch_policy.required_pull_request_reviews
}
