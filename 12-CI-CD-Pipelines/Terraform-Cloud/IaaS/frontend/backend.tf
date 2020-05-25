terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "LukeLab"

    workspaces {
      name = "Azure-Prod-Lukelab-frontend"
    }
  }
}

