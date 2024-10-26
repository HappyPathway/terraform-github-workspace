# main.tf
module "github_actions" {
  source    = "./.." # Path to the root of the module
  repo_name = "terraform-github-workspace"
  repo_org  = "HappyPathway"
  environments = [
    {
      name = "production"
      reviewers = {
        enforce_reviewers = true
        teams             = ["terrform-reviewers"]
      }
      deployment_branch_policy = {
        restrict_branches = false
      }
    }
  ]
}
