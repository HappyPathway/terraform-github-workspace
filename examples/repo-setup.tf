module "repo" {
  source   = "HappyPathway/repo/github"
  github_repo_description = each.value.description
  repo_org                = each.value.repo_org
  name                    = each.value.name
  github_repo_topics      = each.value.repo_topics
  is_template             = each.value.is_template
  force_name              = true
  create_codeowners       = false
  enforce_prs             = each.value.enforce_prs
  collaborators           = local.collaborators
  pull_request_bypassers  = local.pull_request_bypassers
  github_is_private       = each.value.is_private
  github_org_teams        = local.github_organization_teams
}
