data "terraform_remote_state" "rg" {
  backend = "remote"

  config = {
    organization = "LukeLab"
    workspaces = {
      name = "Azure-Prod-Lukelab-rg"
    }
  }
}