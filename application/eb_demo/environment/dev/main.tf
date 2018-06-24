### This main.tf file will use the testwebapp template as a module
### in order to provision the EB environment
### and output the DNS reccord for the EB environment

terraform {
  backend "s3" {
    bucket = "terraform-remote-state-dev"
    key    = "eb_demo/terraform.tfstate"
    region = "eu-west-1"
  }
}

# Getting the EB application name
data "terraform_remote_state" "demo-noenv-state" {
  backend = "s3"
  config {
    bucket = "terraform-remote-state-noenv"
    key = "eb_demo/terraform.tfstate"
    region = "eu-west-1"
  }
}

module "demo-app" {
  source                = "../../main"
  env                   = "dev"
  app_name              = "${data.terraform_remote_state.demo-noenv-state.app-name}"

}

output "dns_record" {
  value = "${module.demo-app.eb-dns-record}"
}
