#data "region" "current" {}

provider "aws" {
  region = var.region
}
