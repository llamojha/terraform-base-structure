### This main.tf file will use the module eb-app
### in order to provision the EB application

terraform {
  backend "s3" {
    bucket = "terraform-remote-state-noenv"
    key    = "eb_demo/terraform.tfstate"
    region = "eu-west-1"
  }
}

module "eb-app" {
  source   = "../../../modules/eb-app"
  app-name = "demo"
}

output "app-name" {
  value = "${module.eb-app.app-id}"
}
