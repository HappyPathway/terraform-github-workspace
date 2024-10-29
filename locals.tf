
locals {
  environments = { for env in var.environments : env.name => env }
  environment_reviewers = {
    for env in var.environments : env.name => lookup(module.context, env.name).review_users
  }
  environment_teams = {
    for env in var.environments : env.name => lookup(module.context, env.name).review_teams
  }
}
