
terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "pisitis"

    workspaces {
      name = "PBL"
    }
  }
}