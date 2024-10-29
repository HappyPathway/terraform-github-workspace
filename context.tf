module "context" {
  source       = "./modules/context"
  for_each     = local.environments
  environment  = each.value
  repo         = var.repo
  state_config = var.state_config
  teams        = data.github_organization_teams.all.teams
}
