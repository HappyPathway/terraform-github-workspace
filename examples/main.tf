# main.tf
module "github_actions" {
  source = "./.." # Path to the root of the module
  repo = {
    name        = "github-workspace-test"
    create_repo = true
    repo_org    = "HappyPathway"
  }
  environments = [
    {
      name = "production"
      reviewers = {
        enforce_reviewers = true
        teams             = ["terraform-reviewers"]
      }
      deployment_branch_policy = {
        restrict_branches = false
      }
    }
  ]
}
